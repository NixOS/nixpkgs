# shellcheck shell=bash

# Guard helper function
# Returns 0 (success) if the hook should be run, 1 (failure) otherwise.
# This allows us to use short-circuit evaluation to avoid running the hook when it shouldn't be.
markForCUDAToolkit_ROOTGuard() {
    local -i hostOffset=${hostOffset:?}
    local -i targetOffset=${targetOffset:?}
    local fnName="mark-for-cudatoolkit-root-hook::markForCUDAToolkit_ROOTGuard hostOffset=$hostOffset targetOffset=$targetOffset"
    local guard=Skipping
    local reason

    # This hook is meant only to add a stub file to the nix-support directory of the package including it in its
    # nativeBuildInputs, so that the setup hook propagated by cuda_nvcc, setup-cuda-hook, can detect it and add the
    # package to the CUDA toolkit root. Therefore, since it only modifies the package being built and will not be
    # propagated, it should only ever be included in nativeBuildInputs.
    if (( hostOffset == -1 && targetOffset == 0)); then
        guard=Sourcing
        reason="because the hook is in nativeBuildInputs relative to the package being built"
    fi

    echo "$fnName: $guard $reason" >&2

    # Recall that test commands return 0 for success and 1 for failure.
    [[ "$guard" == Sourcing ]]
    return $?
}

# Guard against calling the hook at the wrong time.
markForCUDAToolkit_ROOTGuard || return 0

# Make a copy of the current offsets, so that we can use them in information messages; this is necessary because the
# offsets are not consistently available in the environment during various phases of the build.
declare -g snapshotHostOffset="${hostOffset:?}"
declare -g snapshotTargetOffset="${targetOffset:?}"

markForCUDAToolkit_ROOTGetFnName() {
    local fnName="mark-for-cudatoolkit-root-hook::${1:?}"
    local hostOffset="${hostOffset:-$snapshotHostOffset}"
    local targetOffset="${targetOffset:-$snapshotTargetOffset}"
    echo "$fnName hostOffset=$hostOffset targetOffset=$targetOffset"
}

markForCUDAToolkit_ROOT() {
    # Name function never needs to have return value checked.
    # shellcheck disable=SC2155
    local fnName="$(markForCUDAToolkit_ROOTGetFnName markForCUDAToolkit_ROOT)"
    echo "$fnName: Running on ${prefix:?}" >&2

    local markerPath="$prefix/nix-support/include-in-cudatoolkit-root"
    mkdir -p "$(dirname "$markerPath")"
    if [[ -f "$markerPath" ]]; then
        (( ${NIX_DEBUG:-0} >= 1 )) && echo "$fnName: $markerPath exists, skipping" >&2
        return 0
    fi

    # Always create the file, even if it's empty, since setup-cuda-hook relies on its existence.
    # However, only populate it if strictDeps is not set.
    touch "$markerPath"
    if [[ -z "${strictDeps-}" ]]; then
        (( ${NIX_DEBUG:-0} >= 1 )) || echo "$fnName: populating $markerPath" >&2
        echo "${pname:?}-${output:?}" > "$markerPath"
    fi
}
fixupOutputHooks+=(markForCUDAToolkit_ROOT)
