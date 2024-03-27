# shellcheck shell=bash

# Guard helper function
# Returns 0 (success) if the hook should be run, 1 (failure) otherwise.
# This allows us to use short-circuit evaluation to avoid running the hook when it shouldn't be.
setupCudaHookGuard() {
    local -i hostOffset=${hostOffset:?}
    local -i targetOffset=${targetOffset:?}
    local fnName="setup-cuda-hook::setupCudaHookGuard hostOffset=$hostOffset targetOffset=$targetOffset"
    local guard=Skipping
    local reason=

    # This hook is meant only to add a stub file to the nix-support directory of the package including it in its
    # nativeBuildInputs, so that the setup hook propagated by cuda_nvcc, setup-cuda-hook, can detect it and add the
    # package to the CUDA toolkit root. Therefore, since it only modifies the package being built and will not be
    # propagated, it should only ever be included in nativeBuildInputs.
    if (( hostOffset == -1 && targetOffset == 0)); then
        guard=Sourcing
        reason="because the hook is in nativeBuildInputs relative to the package being built"
    elif [[ -n "${cudaSetupHookOnce-}" ]]; then
        guard=Skipping
        reason="because the hook has been propagated more than once"
    fi

    echo "$fnName: $guard $reason" >&2

    # Recall that test commands return 0 for success and 1 for failure.
    [[ "$guard" == Sourcing ]]
    return $?
}

# Guard against calling the hook at the wrong time.
setupCudaHookGuard || return 0

declare -g cudaSetupHookOnce=1
declare -Ag cudaHostPathsSeen=()
declare -Ag cudaOutputToPath=()

# Make a copy of the current offsets, so that we can use them in information messages; this is necessary because the
# offsets are not consistently available in the environment during various phases of the build.
declare -g snapshotHostOffset="${hostOffset:?}"
declare -g snapshotTargetOffset="${targetOffset:?}"

setupCudaHookGetFnName() {
    local fnName="setup-cuda-hook::${1:?}"
    local hostOffset="${hostOffset:-$snapshotHostOffset}"
    local targetOffset="${targetOffset:-$snapshotTargetOffset}"
    echo "$fnName hostOffset=$hostOffset targetOffset=$targetOffset"
}

extendCudaHostPathsSeen() {
    # Name function never needs to have return value checked.
    # shellcheck disable=SC2155
    local fnName="$(setupCudaHookGetFnName extendCudaHostPathsSeen)"
    local markerPath="$1/nix-support/include-in-cudatoolkit-root"
    (( ${NIX_DEBUG:-0} >= 1 )) && echo "$fnName: checking for existence of $markerPath" >&2

    if [[ ! -f "$markerPath" ]]; then
        (( ${NIX_DEBUG:-0} >= 1 )) && echo "$fnName: skipping since $markerPath does not exist" >&2
        return 0
    fi

    if [[ -v cudaHostPathsSeen["$1"] ]]; then
        (( ${NIX_DEBUG:-0} >= 1 )) && echo "$fnName: skipping since $1 has already been seen" >&2
        return 0
    fi

    # Add the path to the list of CUDA host paths.
    cudaHostPathsSeen["$1"]=1
    (( ${NIX_DEBUG:-0} >= 1 )) && echo "$fnName: added $1 to cudaHostPathsSeen" >&2

    # Only attempt to read the file referenced by markerPath if strictDeps is not set; otherwise it is blank and we
    # don't need to read it.
    [[ -n "${strictDeps-}" ]] && return 0

    # E.g. cuda_cudart-lib
    local cudaOutputName
    # Fail gracefully if the file is empty. This may happen if the package was built with strictDeps set,
    # but the current build does not have strictDeps set.
    read -r cudaOutputName < "$markerPath" || return 0

    [[ -z "$cudaOutputName" ]] && return 0

    local oldPath="${cudaOutputToPath[$cudaOutputName]-}"
    [[ -n "$oldPath" ]] && echo "$fnName: warning: overwriting $cudaOutputName from $oldPath to $1" >&2
    cudaOutputToPath["$cudaOutputName"]="$1"
}
addEnvHooks "${targetOffset:?}" extendCudaHostPathsSeen

setupCUDAToolkit_ROOT() {
    # Name function never needs to have return value checked.
    # shellcheck disable=SC2155
    local fnName="$(setupCudaHookGetFnName setupCUDAToolkit_ROOT)"
    (( ${NIX_DEBUG:-0} >= 1 )) && echo "$fnName: cudaHostPathsSeen=${!cudaHostPathsSeen[*]}" >&2

    for path in "${!cudaHostPathsSeen[@]}"; do
        addToSearchPathWithCustomDelimiter ";" CUDAToolkit_ROOT "$path"
        [[ -d "$path/include" ]] && addToSearchPathWithCustomDelimiter ";" CUDAToolkit_INCLUDE_DIR "$path/include"
    done

    export cmakeFlagsArray+=(
        -DCUDAToolkit_INCLUDE_DIR="${CUDAToolkit_INCLUDE_DIR:-}"
        -DCUDAToolkit_ROOT="${CUDAToolkit_ROOT:-}"
    )
}
preConfigureHooks+=(setupCUDAToolkit_ROOT)

setupCUDAToolkitCompilers() {
    # Name function never needs to have return value checked.
    # shellcheck disable=SC2155
    local fnName="$(setupCudaHookGetFnName setupCUDAToolkitCompilers)"
    echo "$fnName: Running" >&2

    [[ -n "${dontSetupCUDAToolkitCompilers-}" ]] && return 0

    # Point NVCC at a compatible compiler

    # For CMake-based projects:
    # https://cmake.org/cmake/help/latest/module/FindCUDA.html#input-variables
    # https://cmake.org/cmake/help/latest/envvar/CUDAHOSTCXX.html
    # https://cmake.org/cmake/help/latest/variable/CMAKE_CUDA_HOST_COMPILER.html

    export cmakeFlagsArray+=(
        -DCUDA_HOST_COMPILER="@ccFullPath@"
        -DCMAKE_CUDA_HOST_COMPILER="@ccFullPath@"
    )

    # For non-CMake projects:
    # We prepend --compiler-bindir to nvcc flags.
    # Downstream packages can override these, because NVCC
    # uses the last --compiler-bindir it gets on the command line.
    # FIXME: this results in "incompatible redefinition" warnings.
    # https://docs.nvidia.com/cuda/cuda-compiler-driver-nvcc/index.html#compiler-bindir-directory-ccbin
    [[ -z "${CUDAHOSTCXX-}" ]] && export CUDAHOSTCXX="@ccFullPath@"

    export NVCC_PREPEND_FLAGS+=" --compiler-bindir=@ccRoot@/bin"

    # NOTE: We set -Xfatbin=-compress-all, which reduces the size of the compiled
    # binaries. If binaries grow over 2GB, they will fail to link. This is a problem for us, as
    # the default set of CUDA capabilities we build can regularly cause this to occur (for
    # example, with Magma).
    #
    # @SomeoneSerge: original comment was made by @ConnorBaker in .../cudatoolkit/common.nix
    [[ -z "${dontCompressFatbin-}" ]] && export NVCC_PREPEND_FLAGS+=" -Xfatbin=-compress-all"
}
preConfigureHooks+=(setupCUDAToolkitCompilers)

propagateCudaLibraries() {
    # Name function never needs to have return value checked.
    # shellcheck disable=SC2155
    local fnName="$(setupCudaHookGetFnName propagateCudaLibraries)"
    (( ${NIX_DEBUG:-0} >= 1 )) && echo "$fnName: cudaPropagateToOutput=$cudaPropagateToOutput cudaHostPathsSeen=${!cudaHostPathsSeen[*]}" >&2

    [[ -z "${cudaPropagateToOutput-}" ]] && return 0

    mkdir -p "${!cudaPropagateToOutput}/nix-support"
    # One'd expect this should be propagated-bulid-build-deps, but that doesn't seem to work
    echo "@setupCudaHook@" >> "${!cudaPropagateToOutput}/nix-support/propagated-native-build-inputs"

    local propagatedBuildInputs=( "${!cudaHostPathsSeen[@]}" )
    for output in $(getAllOutputNames); do
        [[ ! "$output" = "$cudaPropagateToOutput" ]] && propagatedBuildInputs+=( "${!output}" ) && break
    done

    # One'd expect this should be propagated-host-host-deps, but that doesn't seem to work
    printWords "${propagatedBuildInputs[@]}" >> "${!cudaPropagateToOutput}/nix-support/propagated-build-inputs"
}
postFixupHooks+=(propagateCudaLibraries)
