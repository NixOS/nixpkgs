# shellcheck shell=bash

# shellcheck disable=SC1091
source "@logFromSetupHook@"

# Guard helper function
# Returns 0 (success) if the hook should be run, 1 (failure) otherwise.
# This allows us to use short-circuit evaluation to avoid running the hook when it shouldn't be.
markForCUDAToolkit_ROOTGuard() {
    log() {
        logFromSetupHook \
            "${1:?}" \
            "mark-for-cudatoolkit-root" \
            "markForCUDAToolkit_ROOTGuard" \
            "${2:?}"
    }
    local guard="Skipping"
    local reason=""

    # This hook is meant only to add a stub file to the nix-support directory of the package including it in its
    # nativeBuildInputs, so that the setup hook propagated by cuda_nvcc, setup-cuda, can detect it and add the
    # package to the CUDA toolkit root. Therefore, since it only modifies the package being built and will not be
    # propagated, it should only ever be included in nativeBuildInputs.
    if (( ${hostOffset:?} == -1 && ${targetOffset:?} == 0)); then
        guard="Sourcing"
        reason="because the hook is in nativeBuildInputs relative to the package being built"
    fi

    log "INFO" "$guard $reason"

    # Recall that test commands return 0 for success and 1 for failure.
    [[ "$guard" == Sourcing ]]
    return $?
}

# Guard against calling the hook at the wrong time.
markForCUDAToolkit_ROOTGuard || return 0

markForCUDAToolkit_ROOT() {
    log() {
        logFromSetupHook \
            "${1:?}" \
            "mark-for-cudatoolkit-root" \
            "markForCUDAToolkit_ROOT" \
            "${2:?}"
    }
    log "INFO" "Running on ${prefix:?}"

    local markerPath="$prefix/nix-support/include-in-cudatoolkit-root"
    mkdir -p "$(dirname "$markerPath")"
    if [[ -f "$markerPath" ]]; then
        log "DEBUG" "$markerPath exists, skipping"
        return 0
    fi

    # Always create the file, even if it's empty, since setup-cuda relies on its existence.
    # However, only populate it if strictDeps is not set.
    touch "$markerPath"
    if [[ -z "${strictDeps-}" ]]; then
        log "DEBUG" "Populating $markerPath"
        echo "${pname:?}-${output:?}" > "$markerPath"
    fi
}
fixupOutputHooks+=(markForCUDAToolkit_ROOT)
