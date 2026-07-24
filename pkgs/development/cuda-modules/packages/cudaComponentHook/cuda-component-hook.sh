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

_cudaValidateHostCompiler() {
  local hostCompiler="$1"

  if [[ $hostCompiler != /* || ! -f $hostCompiler || ! -x $hostCompiler ]]; then
    _cudaError "host compiler is not an absolute executable file: $hostCompiler"
    return 1
  fi
}

_cudaAddOutputDirectories() {
  local roleSuffix="$1"
  local componentPath="$2"

  [[ ! -d "$componentPath/include" ]] ||
    addToSearchPath "NIX_CUDA_INCLUDE_PATH${roleSuffix}" "$componentPath/include"
  [[ ! -d "$componentPath/lib" ]] ||
    addToSearchPath "NIX_CUDA_LIBRARY_PATH${roleSuffix}" "$componentPath/lib"
  [[ ! -d "$componentPath/lib64" ]] ||
    addToSearchPath "NIX_CUDA_LIBRARY_PATH${roleSuffix}" "$componentPath/lib64"
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
      format | component | output | cudaMajorMinorVersion | cudaComponentVersion | compiler | hostCompiler) ;;
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
  local hostCompiler="${cudaComponentMetadata[hostCompiler]-}"

  if [[ $format != 3 || -z $component || -z $output || -z $cudaComponentVersion ]]; then
    _cudaError "invalid component metadata in $metadataPath"
    return 1
  fi
  _cudaValidateIdentifier "component name" "$component"
  _cudaValidateIdentifier "output name" "$output"
  [[ -z $hostCompiler ]] || _cudaValidateHostCompiler "$hostCompiler"
  if [[ -n $hostCompiler && -z $compiler ]]; then
    _cudaError "hostCompiler requires compiler in $metadataPath"
    return 1
  fi

  local role_post
  local compilerPath=
  if [[ -n $compiler ]]; then
    # Compilers are tools for producing code for their target platform.
    if [[ -n ${strictDeps-} ]]; then
      getTargetRoleEnvHook
    else
      role_post=
    fi

    _cudaResolveCompiler "$componentPath" "$compiler" compilerPath
  else
    # Headers and libraries are consumed by code for their host platform.
    if [[ -n ${strictDeps-} ]]; then
      getHostRoleEnvHook
    else
      role_post=
    fi
  fi

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

  # The registry includes compiler providers as components. Dependency
  # propagation still distinguishes host components from native compiler tools.
  addToSearchPathWithCustomDelimiter \
    ";" \
    "NIX_CUDA_COMPONENT_PATH${role_post}" \
    "$componentPath"
  _cudaAddOutputDirectories "$role_post" "$componentPath"

  # Like cc-wrapper and bintools-wrapper, only expose a compiler as a build
  # tool when its host platform is BUILD and it can therefore execute during
  # this build. Still register compilers carried for HOST or TARGET: they may
  # provide headers or be legitimate runtime/JIT dependencies.
  if [[ -n $compiler && (-z ${strictDeps-} || $depHostOffset -lt 0) ]]; then
    _cudaExportUnique "NIX_CUDA_COMPILER${role_post}" "$compilerPath" "CUDA compilers"
    _cudaExportUnique "NIX_CUDA_COMPILER_ROOT${role_post}" "$componentPath" "CUDA compiler roots"
    [[ -z $hostCompiler ]] ||
      _cudaExportUnique "NIX_CUDA_HOST_COMPILER${role_post}" "$hostCompiler" "CUDA host compilers"
  fi

  _cudaCollectedDependencies["$collectionKey"]=1
}

# addEnvHooks is indexed by the dependency's host offset. Register every
# offset so one hook instance can collect independent BUILD, HOST, and TARGET
# component sets.
addEnvHooks -1 _cudaCollectComponent
addEnvHooks 0 _cudaCollectComponent
addEnvHooks 1 _cudaCollectComponent

_cudaAppendFlags() {
  local variableName="$1"
  shift
  local currentValue=
  if isDeclaredArray "$variableName"; then
    local -n variableReference="$variableName"
    currentValue="${variableReference[*]}"
  else
    currentValue="${!variableName-}"
  fi

  unset -v "$variableName"
  export "$variableName=${currentValue}${currentValue:+ }$*"
}

_cudaFindHostCompiler() {
  local resultVariable="$1"
  local compiler="${CXX-}"
  local compatibleCompiler="${NIX_CUDA_HOST_COMPILER-}"
  local resolvedCompiler=

  # NVCC's component records the host compiler selected by backendStdenv.
  # Prefer it for native builds: the consumer's ordinary stdenv compiler may
  # be newer than NVCC supports. A target-prefixed or absolute CXX denotes a
  # consumer-selected cross/custom compiler and must take precedence.
  if [[ -n $compatibleCompiler && $compiler =~ ^(c\+\+|g\+\+|clang\+\+)?$ ]]; then
    resolvedCompiler="$compatibleCompiler"
  elif [[ $compiler == /* ]]; then
    resolvedCompiler="$compiler"
  elif [[ -n $compiler && -n ${NIX_CC-} && -x ${NIX_CC}/bin/$compiler ]]; then
    resolvedCompiler="${NIX_CC}/bin/$compiler"
  elif [[ -n $compiler ]]; then
    resolvedCompiler="$(type -P -- "$compiler" || true)"
  fi

  [[ -n $resolvedCompiler ]] || resolvedCompiler="$compatibleCompiler"
  [[ -z $resolvedCompiler || (-f $resolvedCompiler && -x $resolvedCompiler) ]] ||
    resolvedCompiler=
  printf -v "$resultVariable" %s "$resolvedCompiler"
}

_cudaFinalizeEnvironment() {
  # FindCUDAToolkit uses CUDAToolkit_ROOT to locate nvcc and then reduces it to
  # one compiler root. Other component roots belong in the component registry;
  # their include and library directories reach build systems through the same
  # compiler and linker search-path mechanisms used elsewhere in stdenv.
  local path
  local hostCompiler=
  local -a paths=()
  local -a nvccFlags=()

  [[ -n ${CUDAToolkit_ROOT-} || -z ${NIX_CUDA_COMPILER_ROOT-} ]] ||
    export CUDAToolkit_ROOT="$NIX_CUDA_COMPILER_ROOT"

  if [[ -n ${NIX_CUDA_COMPILER-} ]]; then
    [[ -n ${CUDACXX-} ]] || export CUDACXX="$NIX_CUDA_COMPILER"

    hostCompiler="${CUDAHOSTCXX-${NVCC_CCBIN-}}"
    [[ -n $hostCompiler ]] || _cudaFindHostCompiler hostCompiler
    [[ -n ${CUDAHOSTCXX-} || -z $hostCompiler ]] ||
      export CUDAHOSTCXX="$hostCompiler"
    [[ -n ${NVCC_CCBIN-} || -z $hostCompiler ]] ||
      export NVCC_CCBIN="$hostCompiler"

    nixInfoLog "selected CUDA compiler: $CUDACXX"
    [[ -z $hostCompiler ]] || nixInfoLog "selected CUDA host compiler: $hostCompiler"
  fi

  # Direct nvcc and JIT invocations do not necessarily consume cc-wrapper's
  # include flags, so also expose every active component include directory to
  # nvcc itself.
  if [[ -n ${NIX_CUDA_INCLUDE_PATH-} ]]; then
    IFS=':' read -r -a paths <<<"$NIX_CUDA_INCLUDE_PATH"
    for path in "${paths[@]}"; do
      [[ -z $path ]] || nvccFlags+=("-I$path")
    done
  fi

  # Large multi-architecture fatbins can otherwise exceed linker size limits.
  [[ -n ${dontCompressCudaFatbins-} ]] ||
    nvccFlags+=("-Xfatbin=-compress-all")

  ((${#nvccFlags[@]} == 0)) ||
    _cudaAppendFlags NVCC_PREPEND_FLAGS "${nvccFlags[@]}"
}

# Finalize during setup.sh evaluation, after every dependency has been passed
# to the environment hooks. No configure phase is required, so this also works
# in nix-shell and nix develop.
postHooks+=(_cudaFinalizeEnvironment)

_cudaMergePropagatedInputs() {
  local file="$1"
  shift

  local -A inputs=()
  local -a existingInputs=()
  if [[ -f $file ]]; then
    read -r -d '' -a existingInputs <"$file" || true
  fi

  local input
  for input in "${existingInputs[@]}" "$@"; do
    # getSortedMapKeys consumes this map through a nameref.
    # shellcheck disable=SC2034
    [[ -z $input ]] || inputs["$input"]=1
  done

  local -a sortedInputs=()
  getSortedMapKeys inputs sortedInputs
  ((${#sortedInputs[@]} > 0)) || return 0
  mkdir -p "${file%/*}"
  printWords "${sortedInputs[@]}" >"$file"
}

_cudaPublishComponentMetadata() {
  [[ -n ${cudaPublishComponent-} ]] || return 0

  local componentPath="${prefix:?}"
  local componentName="${cudaComponentName-${pname:?}}"
  local componentVersion="${cudaComponentVersion-${version:?}}"
  _cudaValidateIdentifier "component name" "$componentName"
  _cudaValidateIdentifier "output name" "${output:?}"
  if [[ -z $componentVersion ]]; then
    _cudaError "cudaComponentVersion is required for $componentName"
    return 1
  fi
  if [[ -n ${cudaHostCompiler-} && -z ${cudaCompilerExecutable-} ]]; then
    _cudaError "cudaHostCompiler requires cudaCompilerExecutable"
    return 1
  fi
  [[ -z ${cudaHostCompiler-} ]] || _cudaValidateHostCompiler "$cudaHostCompiler"
  if [[ -n ${cudaCompilerExecutable-} ]]; then
    local compilerPath
    _cudaResolveCompiler "$componentPath" "$cudaCompilerExecutable" compilerPath
  fi

  local metadataDirectory="$componentPath/nix-support"
  mkdir -p "$metadataDirectory"

  local -A cudaComponentMetadata=(
    [format]=3
    [component]="$componentName"
    [output]="${output:?}"
    [cudaComponentVersion]="$componentVersion"
  )
  [[ -z ${cudaMajorMinorVersion-} ]] ||
    cudaComponentMetadata[cudaMajorMinorVersion]="$cudaMajorMinorVersion"
  [[ -z ${cudaCompilerExecutable-} ]] ||
    cudaComponentMetadata[compiler]="$cudaCompilerExecutable"
  [[ -z ${cudaHostCompiler-} ]] ||
    cudaComponentMetadata[hostCompiler]="$cudaHostCompiler"

  declare -p cudaComponentMetadata >"$metadataDirectory/cuda-component"
  nixDebugLog "published CUDA component metadata for $componentName:${output:?} in $componentPath"
}

_cudaInstallComponentSetupHooks() {
  [[ -n ${cudaPublishComponent-} ]] || return 0

  # Each independently consumable output registers itself using Nixpkgs'
  # standard setup-hook mechanism. fixupPhase has already installed any
  # package-specific hook; prepend registration so an early return in that hook
  # cannot skip the component collector.
  local outputName
  for outputName in $(getAllOutputNames); do
    local componentPath="${!outputName}"
    [[ -f "$componentPath/nix-support/cuda-component" ]] || continue

    local setupHookPath="$componentPath/nix-support/setup-hook"
    local collectorPath="${_cudaComponentHookPath:?}/nix-support/setup-hook"
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

  local -a dependencyAccumulators=()
  getSortedMapKeys _cudaPropagationFileByAccumulator dependencyAccumulators

  local dependencyAccumulator
  for dependencyAccumulator in "${dependencyAccumulators[@]}"; do
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

fixupOutputHooks+=(_cudaPublishComponentMetadata)
postFixupHooks+=(
  _cudaInstallComponentSetupHooks
  _cudaPropagateComponentDependencies
)
