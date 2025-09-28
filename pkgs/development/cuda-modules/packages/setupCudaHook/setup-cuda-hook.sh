# shellcheck shell=bash

# Only run the hook from nativeBuildInputs
(( "$hostOffset" == -1 && "$targetOffset" == 0)) || return 0

guard=Sourcing
reason=

[[ -n ${cudaSetupHookOnce-} ]] && guard=Skipping && reason=" because the hook has been propagated more than once"

if (( "${NIX_DEBUG:-0}" >= 1 )) ; then
    echo "$guard hostOffset=$hostOffset targetOffset=$targetOffset setup-cuda-hook$reason" >&2
else
    echo "$guard setup-cuda-hook$reason" >&2
fi

[[ "$guard" = Sourcing ]] || return 0

declare -g cudaSetupHookOnce=1
declare -Ag cudaHostPathsSeen=()
declare -Ag cudaOutputToPath=()

extendcudaHostPathsSeen() {
    (( "${NIX_DEBUG:-0}" >= 1 )) && echo "extendcudaHostPathsSeen $1" >&2

    local markerPath="$1/nix-support/include-in-cudatoolkit-root"
    [[ ! -f "${markerPath}" ]] && return 0
    [[ -v cudaHostPathsSeen[$1] ]] && return 0

    cudaHostPathsSeen["$1"]=1

    # E.g. cuda_cudart-lib
    local cudaOutputName
    # Fail gracefully if the file is empty.
    # One reason the file may be empty: the package was built with strictDeps set, but the current build does not have
    # strictDeps set.
    read -r cudaOutputName < "$markerPath" || return 0

    [[ -z "$cudaOutputName" ]] && return 0

    local oldPath="${cudaOutputToPath[$cudaOutputName]-}"
    [[ -n "$oldPath" ]] && echo "extendcudaHostPathsSeen: warning: overwriting $cudaOutputName from $oldPath to $1" >&2
    cudaOutputToPath["$cudaOutputName"]="$1"
}
addEnvHooks "$targetOffset" extendcudaHostPathsSeen

setupCUDAToolkit_ROOT() {
    (( "${NIX_DEBUG:-0}" >= 1 )) && echo "setupCUDAToolkit_ROOT: cudaHostPathsSeen=${!cudaHostPathsSeen[*]}" >&2

    for path in "${!cudaHostPathsSeen[@]}" ; do
        addToSearchPathWithCustomDelimiter ";" CUDAToolkit_ROOT "$path"
        if [[ -d "$path/include" ]] ; then
            addToSearchPathWithCustomDelimiter ";" CUDAToolkit_INCLUDE_DIR "$path/include"
        fi
    done

    # Use array form so semicolon-separated lists are passed safely.
    if [[ -n "${CUDAToolkit_INCLUDE_DIR-}" ]]; then
        cmakeFlagsArray+=("-DCUDAToolkit_INCLUDE_DIR=${CUDAToolkit_INCLUDE_DIR}")
    fi
    if [[ -n "${CUDAToolkit_ROOT-}" ]]; then
        cmakeFlagsArray+=("-DCUDAToolkit_ROOT=${CUDAToolkit_ROOT}")
    fi
}
preConfigureHooks+=(setupCUDAToolkit_ROOT)

setupCUDAToolkitCompilers() {
    echo Executing setupCUDAToolkitCompilers >&2

    if [[ -n "${dontSetupCUDAToolkitCompilers-}" ]] ; then
        return 0
    fi

    # Point NVCC at a compatible compiler

    # For CMake-based projects:
    # https://cmake.org/cmake/help/latest/module/FindCUDA.html#input-variables
    # https://cmake.org/cmake/help/latest/envvar/CUDAHOSTCXX.html
    # https://cmake.org/cmake/help/latest/variable/CMAKE_CUDA_HOST_COMPILER.html

    appendToVar cmakeFlags "-DCUDA_HOST_COMPILER=@ccFullPath@"
    appendToVar cmakeFlags "-DCMAKE_CUDA_HOST_COMPILER=@ccFullPath@"

    # For non-CMake projects:
    # We prepend --compiler-bindir to nvcc flags.
    # Downstream packages can override these, because NVCC
    # uses the last --compiler-bindir it gets on the command line.
    # FIXME: this results in "incompatible redefinition" warnings.
    # https://docs.nvidia.com/cuda/cuda-compiler-driver-nvcc/index.html#compiler-bindir-directory-ccbin
    if [ -z "${CUDAHOSTCXX-}" ]; then
      export CUDAHOSTCXX="@ccFullPath@";
    fi

    appendToVar NVCC_PREPEND_FLAGS "--compiler-bindir=@ccRoot@/bin"

    # NOTE: We set -Xfatbin=-compress-all, which reduces the size of the compiled
    #   binaries. If binaries grow over 2GB, they will fail to link. This is a problem for us, as
    #   the default set of CUDA capabilities we build can regularly cause this to occur (for
    #   example, with Magma).
    #
    # @SomeoneSerge: original comment was made by @ConnorBaker in .../cudatoolkit/common.nix
    if [[ -z "${dontCompressFatbin-}" ]]; then
        appendToVar NVCC_PREPEND_FLAGS "-Xfatbin=-compress-all"
    fi
}
preConfigureHooks+=(setupCUDAToolkitCompilers)

propagateCudaLibraries() {
    (( "${NIX_DEBUG:-0}" >= 1 )) && echo "propagateCudaLibraries: cudaPropagateToOutput=$cudaPropagateToOutput cudaHostPathsSeen=${!cudaHostPathsSeen[*]}" >&2

    [[ -z "${cudaPropagateToOutput-}" ]] && return 0

    mkdir -p "${!cudaPropagateToOutput}/nix-support"
    # One'd expect this should be propagated-bulid-build-deps, but that doesn't seem to work
    echo "@setupCudaHook@" >> "${!cudaPropagateToOutput}/nix-support/propagated-native-build-inputs"

    local propagatedBuildInputs=( "${!cudaHostPathsSeen[@]}" )
    for output in $(getAllOutputNames) ; do
        if [[ ! "$output" = "$cudaPropagateToOutput" ]] ; then
            appendToVar propagatedBuildInputs "${!output}"
        fi
        break
    done

    # One'd expect this should be propagated-host-host-deps, but that doesn't seem to work
    printWords "${propagatedBuildInputs[@]}" >> "${!cudaPropagateToOutput}/nix-support/propagated-build-inputs"
}
postFixupHooks+=(propagateCudaLibraries)
