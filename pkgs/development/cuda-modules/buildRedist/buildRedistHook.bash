# shellcheck shell=bash

if [[ -n ${strictDeps:-} && ${hostOffset:-0} -ne -1 ]]; then
  nixLog "skipping sourcing buildRedistHook.bash (hostOffset=${hostOffset:-0}) (targetOffset=${targetOffset:-0})"
  return 0
fi
nixLog "sourcing buildRedistHook.bash (hostOffset=${hostOffset:-0}) (targetOffset=${targetOffset:-0})"

buildRedistHookRegistration() {
  postUnpackHooks+=(unpackCudaLibSubdir)
  nixLog "added unpackCudaLibSubdir to postUnpackHooks"

  postUnpackHooks+=(unpackCudaPkgConfigDirs)
  nixLog "added unpackCudaPkgConfigDirs to postUnpackHooks"

  prePatchHooks+=(patchCudaPkgConfig)
  nixLog "added patchCudaPkgConfig to prePatchHooks"

  if [[ -z ${allowFHSReferences-} ]]; then
    postInstallCheckHooks+=(checkCudaFhsRefs)
    nixLog "added checkCudaFhsRefs to postInstallCheckHooks"
  fi

  postInstallCheckHooks+=(checkCudaNonEmptyOutputs)
  nixLog "added checkCudaNonEmptyOutputs to postInstallCheckHooks"

  postFixupHooks+=(fixupCudaPropagatedBuildOutputsToOut)
  nixLog "added fixupCudaPropagatedBuildOutputsToOut to postFixupHooks"

  # recordPropagatedDependencies replaces these files during fixupPhase.
  postFixupHooks+=(fixupCudaStubOutputs)
}

buildRedistHookRegistration

unpackCudaLibSubdir() {
  local -r cudaLibDir="${NIX_BUILD_TOP:?}/${sourceRoot:?}/lib"
  local -r versionedCudaLibDir="$cudaLibDir/${cudaMajorVersion:?}"

  if [[ ! -d $versionedCudaLibDir ]]; then
    return 0
  fi

  nixLog "found versioned CUDA lib dir: $versionedCudaLibDir"

  mv \
    --verbose \
    --no-clobber \
    "$versionedCudaLibDir" \
    "${cudaLibDir}-new"
  rm --verbose --recursive "$cudaLibDir" || {
    nixErrorLog "could not delete $cudaLibDir: $(ls -laR "$cudaLibDir")"
    exit 1
  }
  mv \
    --verbose \
    --no-clobber \
    "${cudaLibDir}-new" \
    "$cudaLibDir"

  return 0
}

# Pkg-config's setup hook expects configuration files in $out/share/pkgconfig
unpackCudaPkgConfigDirs() {
  local path
  local -r pkgConfigDir="${NIX_BUILD_TOP:?}/${sourceRoot:?}/share/pkgconfig"

  for path in "${NIX_BUILD_TOP:?}/${sourceRoot:?}"/{pkg-config,pkgconfig}; do
    [[ -d $path ]] || continue
    mkdir -p "$pkgConfigDir"
    mv \
      --verbose \
      --no-clobber \
      --target-directory "$pkgConfigDir" \
      "$path"/*
    rm --recursive --dir "$path" || {
      nixErrorLog "$path contains non-empty directories: $(ls -laR "$path")"
      exit 1
    }
  done

  return 0
}

patchCudaPkgConfig() {
  local pc

  for pc in "${NIX_BUILD_TOP:?}/${sourceRoot:?}"/share/pkgconfig/*.pc; do
    nixLog "patching $pc"
    sed -i \
      -e "s|^cudaroot\s*=.*\$|cudaroot=${!outputDev:?}|" \
      -e "s|^libdir\s*=.*/lib\$|libdir=${!outputLib:?}/lib|" \
      -e "s|^includedir\s*=.*/include\$|includedir=${!outputInclude:?}/include|" \
      "$pc"
  done

  for pc in "${NIX_BUILD_TOP:?}/${sourceRoot:?}"/share/pkgconfig/*-"${cudaMajorMinorVersion:?}.pc"; do
    nixLog "creating unversioned symlink for $pc"
    ln -s "$(basename "$pc")" "${pc%-"${cudaMajorMinorVersion:?}".pc}".pc
  done

  return 0
}

checkCudaFhsRefs() {
  nixLog "checking for FHS references..."
  local -a outputPaths=()
  local firstMatches

  mapfile -t outputPaths < <(for outputName in $(getAllOutputNames); do echo "${!outputName:?}"; done)
  firstMatches="$(grep --max-count=5 --recursive --exclude=LICENSE /usr/ "${outputPaths[@]}")" || true
  if [[ -n $firstMatches ]]; then
    nixErrorLog "detected references to /usr: $firstMatches"
    exit 1
  fi

  return 0
}

checkCudaNonEmptyOutputs() {
  local outputName
  local dirs
  local -a failingOutputNames=()

  for outputName in $(getAllOutputNames); do
    # NOTE: Reminder that outputDev is the name of the dev output, so we compare it as-is against outputName rather
    # than using !outputDev, which would give us the path to the dev output.
    [[ ${outputName:?} == "out" || ${outputName:?} == "${outputDev:?}" ]] && continue
    dirs="$(find "${!outputName:?}" -mindepth 1 -maxdepth 1)" || true
    if [[ -z $dirs || $dirs == "${!outputName:?}/nix-support" ]]; then
      failingOutputNames+=("${outputName:?}")
    fi
  done

  if ((${#failingOutputNames[@]})); then
    nixErrorLog "detected empty (excluding nix-support) outputs: ${failingOutputNames[*]}"
    nixErrorLog "this typically indicates a failure in packaging or moveToOutput ordering"
    exit 1
  fi

  return 0
}

# Stub libraries are link-time providers. Keep the conventional stub-only
# output as well as archive stub directories in collapsed or renamed outputs.
fixupCudaStubOutputs() {
  local outputName stubDirectory
  for outputName in $(getAllOutputNames); do
    stubDirectory=$(find "${!outputName:?}" -type d -name stubs -print -quit) || return
    [[ $outputName == stubs || -n $stubDirectory ]] || continue
    mkdir -p "${!outputName:?}/nix-support"
    printWords "${cudaStubRunpathHook:?}" >> "${!outputName:?}/nix-support/propagated-native-build-inputs"
  done
}

# Preserve the aggregate out interface as well as the standard development
# output. The standard hook owns both the array/string handling and file writes.
# This must run after recordPropagatedDependencies, which replaces those files.
fixupCudaPropagatedBuildOutputsToOut() {
  [[ $outputDev != out ]] || return 0
  mkdir -p "${out:?}/nix-support"
  local devOutput="$outputDev" output
  local -a requiredOutputs=()
  concatTo requiredOutputs propagatedBuildOutputs
  local -a propagatedBuildOutputs=()
  for output in "${requiredOutputs[@]}"; do
    # If dev already depends on an out payload, omit the reverse edge.
    [[ $output != "$devOutput" || " ${requiredOutputs[*]} " != *" out "* ]] || continue
    propagatedBuildOutputs+=("$output")
  done
  local outputDev=out
  _multioutPropagateDev
}
