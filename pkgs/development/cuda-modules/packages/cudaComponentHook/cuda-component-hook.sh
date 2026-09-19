# shellcheck shell=bash

# A CUDA component is a package output that contributes a compiler, headers,
# or libraries to a CUDA development environment. Component packages publish
# metadata; this hook collects it according to dependency role and projects it
# into the environment expected by CUDA-aware tools.

declare -Ag _cudaCollectedDependencies=()
declare -Ag _cudaComponentRegistry=()
declare -Ag _cudaPropagationFileByAccumulator=()

_cudaCapturePropagationFiles() {
  # setup.sh unsets these arrays-of-array names after running environment
  # hooks, but leaves the dependency accumulators themselves available to
  # build phases. Preserve its complete accumulator-to-file mapping rather
  # than reconstructing dependency-offset semantics here.
  local groupIndex
  local dependencyIndex
  # shellcheck disable=SC2154
  for groupIndex in "${!pkgAccumVarVars[@]}"; do
    local -n accumulatorNames="${pkgAccumVarVars[groupIndex]}"
    local -n propagationFileNames="${propagatedDepFilesVars[groupIndex]}"

    for dependencyIndex in "${!accumulatorNames[@]}"; do
      _cudaPropagationFileByAccumulator["${accumulatorNames[dependencyIndex]}"]="${propagationFileNames[dependencyIndex]}"
    done
  done
}

_cudaCapturePropagationFiles
unset -f _cudaCapturePropagationFiles

_cudaError() {
  if [[ -n ${NIX_LOG_FD-} ]]; then
    nixErrorLog "$*"
  else
    printf 'cuda-component-hook: %s\n' "$*" >&2
  fi
}

_cudaValidateIdentifier() {
  local description="$1"
  local value="$2"

  if [[ ! $value =~ ^[A-Za-z0-9][A-Za-z0-9._+-]*$ ]]; then
    _cudaError "invalid $description: $value"
    return 1
  fi
}

_cudaExportUnique() {
  local variableName="$1"
  local value="$2"
  local description="$3"
  local existingValue="${!variableName-}"

  if [[ -n $existingValue && $existingValue != "$value" ]]; then
    _cudaError \
      "conflicting $description for $variableName:"$'\n' \
      "  existing: $existingValue"$'\n' \
      "  new:      $value"
    return 1
  fi

  export "$variableName=$value"
}

_cudaResolveCompiler() {
  local componentPath="$1"
  local compiler="$2"
  local resultVariable="$3"

  if [[ $compiler == /* || /$compiler/ == */../* ]]; then
    _cudaError "compiler must be relative to its component output: $compiler"
    return 1
  fi

  local resolvedCompiler="$componentPath/$compiler"
  if [[ ! -f $resolvedCompiler || ! -x $resolvedCompiler ]]; then
    _cudaError "compiler is not an executable file: $resolvedCompiler"
    return 1
  fi

  printf -v "$resultVariable" %s "$resolvedCompiler"
}

_cudaCollectComponent() {
  local componentPath="$1"
  local metadataPath="$componentPath/nix-support/cuda-component"

  [[ -f $metadataPath ]] || return 0

  # Without strictDeps, stdenv applies every environment hook to every
  # dependency. Since this collector is registered for all three host offsets,
  # that would otherwise source each component's metadata six times.
  local collectionKey="$componentPath"
  if [[ -n ${strictDeps-} ]]; then
    collectionKey="${depHostOffset:?}:${depTargetOffset:?}:$componentPath"
  fi
  if [[ -n ${_cudaCollectedDependencies[$collectionKey]-} ]]; then
    nixVomitLog "already collected CUDA component dependency $collectionKey"
    return 0
  fi

  # Component metadata is trusted to the same extent as the setup hooks carried
  # by the dependency. `declare -p` provides Bash's quoted representation of
  # the associative array, so sourcing it is the matching deserializer.
  local -A cudaComponentMetadata=()
  # shellcheck disable=SC1090
  source "$metadataPath"

  local key
  for key in "${!cudaComponentMetadata[@]}"; do
    case "$key" in
      format | component | output | cudaMajorMinorVersion | cudaComponentVersion | compiler) ;;
      *)
        _cudaError "unknown field \"$key\" in $metadataPath"
        return 1
        ;;
    esac
  done

  local format="${cudaComponentMetadata[format]-}"
  local component="${cudaComponentMetadata[component]-}"
  local output="${cudaComponentMetadata[output]-}"
  local cudaMajorMinorVersion="${cudaComponentMetadata[cudaMajorMinorVersion]-}"
  local cudaComponentVersion="${cudaComponentMetadata[cudaComponentVersion]-}"
  local compiler="${cudaComponentMetadata[compiler]-}"

  if [[ $format != 3 || -z $component || -z $output || -z $cudaComponentVersion ]]; then
    _cudaError "invalid component metadata in $metadataPath"
    return 1
  fi
  _cudaValidateIdentifier "component name" "$component"
  _cudaValidateIdentifier "output name" "$output"
  local role_post=
  local compilerPath=
  if [[ -n ${strictDeps-} ]]; then
    # Compilers produce code for TARGET; headers and libraries describe HOST.
    if [[ -n $compiler ]]; then
      getTargetRoleEnvHook
    else
      getHostRoleEnvHook
    fi
  fi
  [[ -z $compiler ]] || _cudaResolveCompiler "$componentPath" "$compiler" compilerPath

  [[ -z $cudaMajorMinorVersion ]] ||
    _cudaExportUnique \
      "NIX_CUDA_MAJOR_MINOR_VERSION${role_post}" \
      "$cudaMajorMinorVersion" \
      "CUDA major-minor versions"

  local dependencyRole="*:*"
  [[ -z ${strictDeps-} ]] ||
    dependencyRole="${depHostOffset:?}:${depTargetOffset:?}"
  local componentKey="${dependencyRole}:${component}:${output}"
  local existingPath="${_cudaComponentRegistry[$componentKey]-}"
  if [[ -n $existingPath && $existingPath != "$componentPath" ]]; then
    _cudaError \
      "conflicting output $component:$output for dependency role $dependencyRole:"$'\n' \
      "  existing: $existingPath"$'\n' \
      "  new:      $componentPath"
    return 1
  fi
  _cudaComponentRegistry["$componentKey"]="$componentPath"
  nixDebugLog "registered CUDA component $component:$output for dependency role $dependencyRole from $componentPath"

  # Like cc-wrapper and bintools-wrapper, only expose a compiler as a build
  # tool when its host platform is BUILD and it can therefore execute during
  # this build. Still register compilers carried for HOST or TARGET: they may
  # provide headers or be legitimate runtime/JIT dependencies.
  if [[ -n $compiler && (-z ${strictDeps-} || $depHostOffset -lt 0) ]]; then
    _cudaExportUnique "NIX_CUDA_COMPILER${role_post}" "$compilerPath" "CUDA compilers"
    _cudaExportUnique "NIX_CUDA_COMPILER_ROOT${role_post}" "$componentPath" "CUDA compiler roots"

    # Publish discovery defaults while the compiler's role is in scope.
    # Explicit caller choices remain authoritative.
    local cudacxxVariable="CUDACXX${role_post}"
    [[ -n ${!cudacxxVariable-} ]] || export "$cudacxxVariable=$compilerPath"
    if [[ -z $role_post && -z ${CUDAToolkit_ROOT-} ]]; then
      export CUDAToolkit_ROOT="$componentPath"
    fi
  fi

  _cudaCollectedDependencies["$collectionKey"]=1
}

# addEnvHooks is indexed by the dependency's host offset. Register every
# offset so one hook instance can collect independent BUILD, HOST, and TARGET
# component sets.
addEnvHooks -1 _cudaCollectComponent
addEnvHooks 0 _cudaCollectComponent
addEnvHooks 1 _cudaCollectComponent

_cudaMergePropagatedInputs() {
  local file="$1"
  shift

  local -A inputs=()
  local -a existingInputs=()
  if [[ -f $file ]]; then
    read -r -d '' -a existingInputs <"$file" || true
  fi

  local -a mergedInputs=()
  local input
  for input in "${existingInputs[@]}" "$@"; do
    [[ -z $input || -n ${inputs[$input]-} ]] && continue
    inputs["$input"]=1
    mergedInputs+=("$input")
  done

  # Dependency order determines search-path precedence. Deduplicate without
  # reordering the caller's inputs or the dependencies appended by this hook.
  ((${#mergedInputs[@]} > 0)) || return 0
  mkdir -p "${file%/*}"
  printWords "${mergedInputs[@]}" >"$file"
}

_cudaPublishComponents() {
  [[ -n ${cudaPublishComponent-} ]] || return 0

  local componentName="${cudaComponentName-${pname:?}}"
  local componentVersion="${cudaComponentVersion-${version:?}}"
  _cudaValidateIdentifier "component name" "$componentName"
  if [[ -z $componentVersion ]]; then
    _cudaError "cudaComponentVersion is required for $componentName"
    return 1
  fi

  local -A cudaComponentMetadata=(
    [format]=3
    [component]="$componentName"
    [cudaComponentVersion]="$componentVersion"
  )
  [[ -z ${cudaMajorMinorVersion-} ]] ||
    cudaComponentMetadata[cudaMajorMinorVersion]="$cudaMajorMinorVersion"
  [[ -z ${cudaCompilerExecutable-} ]] ||
    cudaComponentMetadata[compiler]="$cudaCompilerExecutable"

  local componentOutputs
  if [[ -n ${cudaCompilerExecutable-} ]]; then
    # A compiler describes its TARGET and belongs to outputBin. Its other
    # outputs may only aggregate the compiler; publishing them as ordinary
    # HOST components would assign their CUDA version to the wrong role.
    componentOutputs="${outputBin:?}"
  else
    componentOutputs="$(getAllOutputNames)"
  fi

  # Publish each output's metadata and activation together. fixupPhase must
  # first install any package-specific setup hook; prepend registration so an
  # early return in that hook cannot skip the component collector.
  local collectorPath="${_cudaComponentHookPath:?}/nix-support/setup-hook"
  local outputName
  for outputName in $componentOutputs; do
    _cudaValidateIdentifier "output name" "$outputName"
    local componentPath="${!outputName:?}"
    if [[ -n ${cudaCompilerExecutable-} ]]; then
      local compilerPath
      _cudaResolveCompiler "$componentPath" "$cudaCompilerExecutable" compilerPath
    fi

    local metadataDirectory="$componentPath/nix-support"
    mkdir -p "$metadataDirectory"
    cudaComponentMetadata[output]="$outputName"
    declare -p cudaComponentMetadata >"$metadataDirectory/cuda-component"
    nixDebugLog "published CUDA component metadata for $componentName:$outputName in $componentPath"

    local setupHookPath="$metadataDirectory/setup-hook"
    local existingSetupHook=
    if [[ -f $setupHookPath ]]; then
      existingSetupHook="$(<"$setupHookPath")"
    fi
    printf 'source %q\n%s\n' \
      "$collectorPath" \
      "$existingSetupHook" \
      >"$setupHookPath"
    nixDebugLog "installed CUDA component setup hook in $componentPath"
  done
}

_cudaPropagateComponentDependencies() {
  local destinationName="${cudaPropagateDependenciesToOutput-}"
  [[ -n $destinationName ]] || return 0

  local destination="${!destinationName-}"
  if [[ -z $destination ]]; then
    _cudaError "cudaPropagateDependenciesToOutput names an unknown output: $destinationName"
    return 1
  fi

  # multiple-outputs.sh resolves this to the package's normal development
  # output (usually `dev`, falling back to `out`). Unlike getAllOutputNames,
  # it is deterministic when structured attributes store outputs in a map.
  local developmentOutputName="${outputDev:?}"

  local dependencyAccumulator
  for dependencyAccumulator in "${!_cudaPropagationFileByAccumulator[@]}"; do
    local -n dependencies="$dependencyAccumulator"
    local -a cudaDependencies=()
    local dependency
    local propagationFile="${_cudaPropagationFileByAccumulator[$dependencyAccumulator]}"

    for dependency in "${dependencies[@]}"; do
      [[ -f "$dependency/nix-support/cuda-component" ]] ||
        continue
      cudaDependencies+=("$dependency")
    done

    # Keep the package's normal development output reachable through its
    # dependency-only development output without propagating that output
    # through itself.
    if [[ $dependencyAccumulator == pkgsHostTarget && $developmentOutputName != "$destinationName" ]]; then
      cudaDependencies+=("${!developmentOutputName}")
    fi

    _cudaMergePropagatedInputs \
      "$destination/nix-support/$propagationFile" \
      "${cudaDependencies[@]}"
    ((${#cudaDependencies[@]} == 0)) ||
      nixDebugLog "propagated ${#cudaDependencies[@]} CUDA dependencies through $destinationName/$propagationFile"
  done
}

postFixupHooks+=(
  _cudaPublishComponents
  _cudaPropagateComponentDependencies
)
