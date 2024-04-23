# shellcheck shell=bash

# Only run the hook from nativeBuildInputs
(( "$hostOffset" == -1 && "$targetOffset" == 0)) || return 0

guard=Sourcing
reason=

(( "${cudaSetupHookOnce:-0}" > 0 )) && guard=Skipping && reason=" because the hook has been propagated more than once"

if (( "${NIX_DEBUG:-0}" >= 1 )) ; then
    echo "$guard hostOffset=$hostOffset targetOffset=$targetOffset setup-cuda-hook$reason" >&2
else
    echo "$guard setup-cuda-hook$reason" >&2
fi

[[ "$guard" = Sourcing ]] || return 0

declare -ig cudaSetupHookOnce=1
declare -Ag cudaHostPathsSeen=()

setupCUDAPopulateArrays() {
    echo "setupCUDAPopulateArrays: executing" >&2

    # These names are all guaranteed to be arrays (though they may be empty), with or without __structuredAttrs set.
    local -a dependencyArrayNames=(
        pkgsBuildBuild
        pkgsBuildHost
        pkgsBuildTarget
        pkgsHostHost
        pkgsHostTarget
        pkgsTargetTarget
    )

    for name in "${dependencyArrayNames[@]}"; do
        (( "${NIX_DEBUG:-0}" >= 1 )) && echo "setupCUDAPopulateArrays: Searching dependencies in $name for CUDA markers" >&2
        local -n deps="$name"
        for dep in "${deps[@]}"; do
            (( "${NIX_DEBUG:-0}" >= 1 )) && echo "setupCUDAPopulateArrays: Checking $dep for CUDA marker" >&2
            if [[ -f "$dep/nix-support/include-in-cudatoolkit-root" ]]; then
                (( "${NIX_DEBUG:-0}" >= 1 )) && echo "setupCUDAPopulateArrays: Found CUDA marker in $dep" >&2
                cudaHostPathsSeen["$dep"]=1
            fi
        done
    done
}
preConfigureHooks+=(setupCUDAPopulateArrays)

setupCUDAEnvironmentVariables() {
    echo "setupCUDAEnvironmentVariables: executing" >&2
    (( "${NIX_DEBUG:-0}" >= 1 )) && echo "setupCUDAEnvironmentVariables: cudaHostPathsSeen=${!cudaHostPathsSeen[*]}" >&2

    for path in "${!cudaHostPathsSeen[@]}" ; do
        addToSearchPathWithCustomDelimiter ";" CUDAToolkit_ROOT "$path"
        if [[ -d "$path/include" ]] ; then
            addToSearchPathWithCustomDelimiter ";" CUDAToolkit_INCLUDE_DIR "$path/include"
        fi
    done

    # Set CUDAHOSTCXX if unset or null
    if [[ -z "${CUDAHOSTCXX:-}" ]]; then
      export CUDAHOSTCXX="@ccFullPath@";
    fi

    # For non-CMake projects:
    # We prepend --compiler-bindir to nvcc flags.
    # Downstream packages can override these, because NVCC
    # uses the last --compiler-bindir it gets on the command line.
    # https://docs.nvidia.com/cuda/cuda-compiler-driver-nvcc/index.html#compiler-bindir-directory-ccbin
    # NOTE: Using "--compiler-bindir" results in "incompatible redefinition"
    # warnings, while using the short form "-ccbin" does not.
    export NVCC_PREPEND_FLAGS+=" -ccbin @ccFullPath@"

    # NOTE: We set -Xfatbin=-compress-all, which reduces the size of the compiled
    #   binaries. If binaries grow over 2GB, they will fail to link. This is a problem for us, as
    #   the default set of CUDA capabilities we build can regularly cause this to occur (for
    #   example, with Magma).
    #
    # @SomeoneSerge: original comment was made by @ConnorBaker in .../cudatoolkit/common.nix
    if [[ -z "${cudaDontCompressFatbin:-}" ]]; then
        export NVCC_PREPEND_FLAGS+=" -Xfatbin=-compress-all"
    fi
}
preConfigureHooks+=(setupCUDAEnvironmentVariables)

setupCUDACmakeFlags() {
    echo "setupCUDACmakeFlags: executing" >&2

    # If CMake is not present, don't set the flags.
    if ! command -v cmake &>/dev/null ; then
        echo "setupCUDACmakeFlags: CMake is not present, not setting flags" >&2
        return 0
    fi

    # NOTE: Historically, we would set the following flags:
    # -DCUDA_HOST_COMPILER=@ccFullPath@
    # -DCMAKE_CUDA_HOST_COMPILER=@ccFullPath@
    # However, as of CMake 3.13, if CUDAHOSTCXX is set, CMake will automatically use it as the host compiler for CUDA.
    # Since we set CUDAHOSTCXX in setupCUDAEnvironmentVariables, we don't need to set these flags anymore.

    # TODO: Should we default to enabling support if CMake is present and the flag is not set?
    if (( "${cudaEnableCmakeFindCudaSupport:-0}" == 1 )) ; then
        echo "setupCUDACmakeFlags: cudaEnableCmakeFindCudaSupport is set, appending -DCUDAToolkit_INCLUDE_DIR and -DCUDAToolkit_ROOT to cmakeFlags" >&2
        export cmakeFlags+=" -DCUDAToolkit_INCLUDE_DIR=${CUDAToolkit_INCLUDE_DIR:-}"
        export cmakeFlags+=" -DCUDAToolkit_ROOT=${CUDAToolkit_ROOT:-}"
    fi

    # Support the legacy flag -DCUDA_TOOLKIT_ROOT_DIR
    if (( "${cudaEnableCmakeFindCudaToolkitSupport:-0}" == 1 )) ; then
        echo "setupCUDACmakeFlags: cudaEnableCmakeFindCudaToolkitSupport is set, appending legacy flag -DCUDA_TOOLKIT_ROOT_DIR to cmakeFlags" >&2
        export cmakeFlags+=" -DCUDA_TOOLKIT_ROOT_DIR=${CUDAToolkit_ROOT:-}"
    fi
}
preConfigureHooks+=(setupCUDACmakeFlags)

propagateCudaLibraries() {
    (( "${NIX_DEBUG:-0}" >= 1 )) && echo "propagateCudaLibraries: cudaPropagateToOutput=$cudaPropagateToOutput cudaHostPathsSeen=${!cudaHostPathsSeen[*]}" >&2

    [[ -z "${cudaPropagateToOutput:-}" ]] && return 0

    mkdir -p "${!cudaPropagateToOutput}/nix-support"
    # One'd expect this should be propagated-bulid-build-deps, but that doesn't seem to work
    printWords "@setupCudaHook@" >> "${!cudaPropagateToOutput}/nix-support/propagated-native-build-inputs"

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
