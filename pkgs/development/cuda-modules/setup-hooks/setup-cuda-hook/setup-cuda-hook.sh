# shellcheck shell=bash

guard=Sourcing
reason=

export NIX_DEBUG=1

# Only run the hook from buildInputs: outside executables like cuda_nvcc, most
# CUDA dependencies are needed at runtime, not build-time.
# See the table under https://nixos.org/manual/nixpkgs/unstable/#dependency-propagation for information
# about the different target combinations and their offsets.
if (( "${hostOffset:?}" != -1 && "${targetOffset:?}" != 0 )); then
    guard=Skipping
    reason=" because the hook is not in nativeBuildInputs"
fi

if [[ -n ${cudaSetupHookOnce-} ]]; then
    guard=Skipping
    reason=" because the hook has been propagated more than once"
fi

if (( "${NIX_DEBUG:-0}" >= 1 )); then
    echo "$guard hostOffset=$hostOffset targetOffset=$targetOffset setup-cuda-hook$reason" >&2
else
    echo "$guard setup-cuda-hook$reason" >&2
fi

[[ "$guard" = Sourcing ]] || return 0

declare -g cudaSetupHookOnce=1
declare -Ag cudaHostPathsSeen=()
declare -Ag cudaOutputToPath=()

extendCudaHostPathsSeen() {
    local fnName=setup-cuda-hook::extendCudaHostPathsSeen
    (( "${NIX_DEBUG:-0}" >= 1 )) && echo "$fnName: $1" >&2

    local markerPath="$1/nix-support/include-in-cudatoolkit-root"
    if [[ ! -f "$markerPath" ]]; then
        (( "${NIX_DEBUG:-0}" >= 1 )) && echo "$fnName: skipping since $markerPath exists" >&2
        return
    fi

    if [[ -v cudaHostPathsSeen[$1] ]]; then
        (( "${NIX_DEBUG:-0}" >= 1 )) && echo "$fnName: skipping since $1 has already been seen" >&2
        return
    fi

    # Add the path to the list of CUDA host paths.
    cudaHostPathsSeen["$1"]=1

    # E.g. cuda_cudart-lib
    local cudaOutputName
    read -r cudaOutputName < "$markerPath"

    [[ -z "$cudaOutputName" ]] && return

    local oldPath="${cudaOutputToPath[$cudaOutputName]-}"
    [[ -n "$oldPath" ]] && echo "$fnName: warning: overwriting $cudaOutputName from $oldPath to $1" >&2
    cudaOutputToPath["$cudaOutputName"]="$1"
}
addEnvHooks "$targetOffset" extendCudaHostPathsSeen

setupCUDAToolkit_ROOT() {
    local fnName=setup-cuda-hook::setupCUDAToolkit_ROOT
    (( "${NIX_DEBUG:-0}" >= 1 )) && echo "$fnName: cudaHostPathsSeen=${!cudaHostPathsSeen[*]}" >&2

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
    local fnName=setup-cuda-hook::setupCUDAToolkitCompilers
    echo "$fnName: Running" >&2

    [[ -n "${dontSetupCUDAToolkitCompilers-}" ]] && return

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
    local fnName=setup-cuda-hook::propagateCudaLibraries
    (( "${NIX_DEBUG:-0}" >= 1 )) && echo "$fnName: cudaPropagateToOutput=$cudaPropagateToOutput cudaHostPathsSeen=${!cudaHostPathsSeen[*]}" >&2

    [[ -z "${cudaPropagateToOutput-}" ]] && return

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
