# shellcheck shell=bash

# shellcheck disable=SC1091
source "@logFromSetupHook@"

# Guard helper function
# Returns 0 (success) if the hook should be run, 1 (failure) otherwise.
# This allows us to use short-circuit evaluation to avoid running the hook when it shouldn't be.
setupCudaGuard() {
    log() {
        logFromSetupHook \
            "${1:?}" \
            "setup-cuda" \
            "setupCudaGuard" \
            "${2:?}"
    }
    local guard="Skipping"
    local reason=""

    if (( ${hostOffset:?} == -1 && ${targetOffset:?} == 0)); then
        guard="Sourcing"
        reason="because the hook is in nativeBuildInputs relative to the package being built"
    elif [[ -n "${cudaSetupOnce-}" ]]; then
        guard=Skipping
        reason="because the hook has been propagated more than once"
    fi

    log "INFO" "$guard $reason"

    # Recall that test commands return 0 for success and 1 for failure.
    [[ "$guard" == Sourcing ]]
    return $?
}

# Guard against calling the hook at the wrong time.
setupCudaGuard || return 0

# NOTE: While it would appear that we are in the global scope, we are not! As such, we must declare these variables as
# global to ensure they are accessible in the global scope.
declare -g cudaSetupOnce=1
declare -gA cudaHostPathsSeen=()
declare -gA cudaOutputToPath=()

extendcudaHostPathsSeen() {
    log() {
        logFromSetupHook \
            "${1:?}" \
            "setup-cuda" \
            "extendcudaHostPathsSeen" \
            "${2:?}"
    }
    local markerPath="${1:?}/nix-support/include-in-cudatoolkit-root"

    log "DEBUG" "checking for existence of $markerPath"

    if [[ ! -f "$markerPath" ]]; then
        log "DEBUG" "skipping since $markerPath does not exist"
        return 0
    fi

    if [[ -v cudaHostPathsSeen["$1"] ]]; then
        log "DEBUG" "skipping since $1 has already been seen"
        return 0
    fi

    cudaHostPathsSeen["$1"]=1
    log "DEBUG" "added $1 to cudaHostPathsSeen"

    # Only attempt to read the file referenced by markerPath if strictDeps is not set; otherwise it is blank and we
    # don't need to read it.
    [[ -n "${strictDeps-}" ]] && return 0

    # E.g. cuda_cudart-lib
    local cudaOutputName
    # Fail gracefully if the file is empty.
    # One reason the file may be empty: the package was built with strictDeps set, but the current build does not have
    # strictDeps set.
    read -r cudaOutputName < "$markerPath" || return 0

    [[ -z "$cudaOutputName" ]] && return 0

    local oldPath="${cudaOutputToPath[$cudaOutputName]-}"
    if [[ -n "$oldPath" ]]; then
        log "WARNING" "overwriting $cudaOutputName from $oldPath to $1"
    fi
    cudaOutputToPath["$cudaOutputName"]="$1"
}
addEnvHooks "$targetOffset" extendcudaHostPathsSeen

setupCUDAToolkit_ROOT() {
    log() {
        logFromSetupHook \
            "${1:?}" \
            "setup-cuda" \
            "setupCUDAToolkit_ROOT" \
            "${2:?}"
    }
    log "DEBUG" "cudaHostPathsSeen is ${!cudaHostPathsSeen[*]}"

    for path in "${!cudaHostPathsSeen[@]}"; do
        addToSearchPathWithCustomDelimiter ";" CUDAToolkit_ROOT "$path"
        [[ -d "$path/include" ]] && addToSearchPathWithCustomDelimiter ";" CUDAToolkit_INCLUDE_DIR "$path/include"
    done

    # NOTE: Due to the way CMake flags are structured within Nixpkgs, there is a distinction between flags set by
    # cmakeFlags, and those set by cmakeFlagsArray (the former is a string, the latter is an array).
    # The setup hook in Nixpkgs, as of this comment, interpolates the cmakeFlags string before expanding the array.
    # Since we want these flags to have the lowest priority (and thus, be overridden), we must set them with
    # cmakeFlags so all user flags will override them.
    export cmakeFlags+=" -DCUDAToolkit_INCLUDE_DIR=\"${CUDAToolkit_INCLUDE_DIR:-}\""
    export cmakeFlags+=" -DCUDAToolkit_ROOT=\"${CUDAToolkit_ROOT:-}\""
}
preConfigureHooks+=(setupCUDAToolkit_ROOT)

setupCUDAToolkitCompilers() {
    log() {
        logFromSetupHook \
            "${1:?}" \
            "setup-cuda" \
            "setupCUDAToolkitCompilers" \
            "${2:?}"
    }

    if [[ -n "${dontSetupCUDAToolkitCompilers-}" ]]; then
        log "INFO" "skipping setup of CUDA toolkit compilers as requested"
        return 0
    else
        log "INFO" "setting up CUDA toolkit compilers"
    fi

    # Point NVCC at a compatible compiler

    # For CMake-based projects:
    # https://cmake.org/cmake/help/latest/module/FindCUDA.html#input-variables
    # https://cmake.org/cmake/help/latest/envvar/CUDAHOSTCXX.html
    # https://cmake.org/cmake/help/latest/variable/CMAKE_CUDA_HOST_COMPILER.html

    # NOTE: See note in setupCUDAToolkit_ROOT about why we use cmakeFlags over cmakeFlagsArray.
    export cmakeFlags+=" -DCUDA_HOST_COMPILER=\"@ccFullPath@\""
    export cmakeFlags+=" -DCMAKE_CUDA_HOST_COMPILER=\"@ccFullPath@\""

    # For non-CMake projects:
    # We prepend --compiler-bindir to nvcc flags.
    # Downstream packages can override these, because NVCC
    # uses the last --compiler-bindir it gets on the command line.
    # FIXME: this results in "incompatible redefinition" warnings.
    # https://docs.nvidia.com/cuda/cuda-compiler-driver-nvcc/index.html#compiler-bindir-directory-ccbin
    [[ -z "${CUDAHOSTCXX-}" ]] && export CUDAHOSTCXX="@ccFullPath@"

    export NVCC_PREPEND_FLAGS+=" --compiler-bindir=\"@ccRoot@/bin\""

    # NOTE: We set -Xfatbin=-compress-all, which reduces the size of the compiled
    #   binaries. If binaries grow over 2GB, they will fail to link. This is a problem for us, as
    #   the default set of CUDA capabilities we build can regularly cause this to occur (for
    #   example, with Magma).
    #
    # @SomeoneSerge: original comment was made by @ConnorBaker in .../cudatoolkit/common.nix
    [[ -z "${dontCompressFatbin-}" ]] && export NVCC_PREPEND_FLAGS+=" -Xfatbin=-compress-all"
}
preConfigureHooks+=(setupCUDAToolkitCompilers)

propagateCudaLibraries() {
    log() {
        logFromSetupHook \
            "${1:?}" \
            "setup-cuda" \
            "propagateCudaLibraries" \
            "${2:?}"
    }

    if [[ -n "${cudaPropagateToOutput-}" ]]; then
        log "INFO" "propagating CUDA libraries to $cudaPropagateToOutput"
    else
        log "DEBUG" "skipping propagation of CUDA libraries since cudaPropagateToOutput is not set"
        return 0
    fi

    log "DEBUG" "cudaHostPathsSeen is ${!cudaHostPathsSeen[*]}"

    mkdir -p "${!cudaPropagateToOutput}/nix-support"
    # One'd expect this should be propagated-bulid-build-deps, but that doesn't seem to work
    echo "@setupCuda@" >> "${!cudaPropagateToOutput}/nix-support/propagated-native-build-inputs"

    local propagatedBuildInputs=( "${!cudaHostPathsSeen[@]}" )
    for output in $(getAllOutputNames); do
        [[ "$output" != "$cudaPropagateToOutput" ]] && propagatedBuildInputs+=( "${!output}" ) && break
    done

    # One'd expect this should be propagated-host-host-deps, but that doesn't seem to work
    printWords "${propagatedBuildInputs[@]}" >> "${!cudaPropagateToOutput}/nix-support/propagated-build-inputs"
}
postFixupHooks+=(propagateCudaLibraries)
