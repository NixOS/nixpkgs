# shellcheck shell=bash

# Only run the hook from nativeBuildInputs
(( "$hostOffset" == -1 && "$targetOffset" == 0)) || return 0

guard=Sourcing
reason=

[[ -n ${cudaSetupHookOnce-} ]] && guard=Skipping && reason=" because the hook has been propagated more than once"

if (( "${NIX_DEBUG:-0}" >= 1 )) ; then
    echo "$guard hostOffset=$hostOffset targetOffset=$targetOffset setupCudaHook$reason" >&2
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
    [[ ! -f "${markerPath}" ]] && return
    [[ -v cudaHostPathsSeen[$1] ]] && return

    cudaHostPathsSeen["$1"]=1

    # E.g. cuda_cudart-lib
    local cudaOutputName
    read -r cudaOutputName < "$markerPath"

    [[ -z "$cudaOutputName" ]] && return

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

    export cmakeFlags+=" -DCUDAToolkit_INCLUDE_DIR=$CUDAToolkit_INCLUDE_DIR -DCUDAToolkit_ROOT=$CUDAToolkit_ROOT"
}
preConfigureHooks+=(setupCUDAToolkit_ROOT)

setupCUDAToolkitCompilers() {
    echo Executing setupCUDAToolkitCompilers >&2

    if [[ -n "${dontSetupCUDAToolkitCompilers-}" ]] ; then
        return
    fi

    # Point NVCC at a compatible compiler

    # For CMake-based projects:
    # https://cmake.org/cmake/help/latest/module/FindCUDA.html#input-variables
    # https://cmake.org/cmake/help/latest/envvar/CUDAHOSTCXX.html
    # https://cmake.org/cmake/help/latest/variable/CMAKE_CUDA_HOST_COMPILER.html

    export cmakeFlags+=" -DCUDA_HOST_COMPILER=@ccFullPath@"
    export cmakeFlags+=" -DCMAKE_CUDA_HOST_COMPILER=@ccFullPath@"

    # For non-CMake projects:
    # We prepend --compiler-bindir to nvcc flags.
    # Downstream packages can override these, because NVCC
    # uses the last --compiler-bindir it gets on the command line.
    # FIXME: this results in "incompatible redefinition" warnings.
    # https://docs.nvidia.com/cuda/cuda-compiler-driver-nvcc/index.html#compiler-bindir-directory-ccbin
    if [ -z "${CUDAHOSTCXX-}" ]; then
      export CUDAHOSTCXX="@ccFullPath@";
    fi

    export NVCC_PREPEND_FLAGS+=" --compiler-bindir=@ccRoot@/bin"

    # NOTE: We set -Xfatbin=-compress-all, which reduces the size of the compiled
    #   binaries. If binaries grow over 2GB, they will fail to link. This is a problem for us, as
    #   the default set of CUDA capabilities we build can regularly cause this to occur (for
    #   example, with Magma).
    #
    # @SomeoneSerge: original comment was made by @ConnorBaker in .../cudatoolkit/common.nix
    if [[ -z "${dontCompressFatbin-}" ]]; then
        export NVCC_PREPEND_FLAGS+=" -Xfatbin=-compress-all"
    fi
}
preConfigureHooks+=(setupCUDAToolkitCompilers)

propagateCudaLibraries() {
    (( "${NIX_DEBUG:-0}" >= 1 )) && echo "propagateCudaLibraries: cudaPropagateToOutput=$cudaPropagateToOutput cudaHostPathsSeen=${!cudaHostPathsSeen[*]}" >&2

    [[ -z "${cudaPropagateToOutput-}" ]] && return

    mkdir -p "${!cudaPropagateToOutput}/nix-support"
    # One'd expect this should be propagated-bulid-build-deps, but that doesn't seem to work
    echo "@setupCudaHook@" >> "${!cudaPropagateToOutput}/nix-support/propagated-native-build-inputs"

    local propagatedBuildInputs=( "${!cudaHostPathsSeen[@]}" )
    for output in $(getAllOutputNames) ; do
        if [[ ! "$output" = "$cudaPropagateToOutput" ]] ; then
            propagatedBuildInputs+=( "${!output}" )
        fi
        break
    done

    # One'd expect this should be propagated-host-host-deps, but that doesn't seem to work
    printWords "${propagatedBuildInputs[@]}" >> "${!cudaPropagateToOutput}/nix-support/propagated-build-inputs"
}
postFixupHooks+=(propagateCudaLibraries)
