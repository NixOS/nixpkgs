# shellcheck shell=bash

guard=Sourcing
reason=

export NIX_DEBUG=1

# Only run the hook from nativeBuildInputs.
# See the table under https://nixos.org/manual/nixpkgs/unstable/#dependency-propagation for information
# about the different target combinations and their offsets.
if (( "${hostOffset:?}" != -1 && "${targetOffset:?}" != 0 )); then
    guard=Skipping
    reason=" because the hook is not in nativeBuildInputs"
fi

if (( "${NIX_DEBUG:-0}" >= 1 )); then
    echo "$guard hostOffset=$hostOffset targetOffset=$targetOffset mark-for-cudatoolkit-root-hook$reason" >&2
else
    echo "$guard mark-for-cudatoolkit-root-hook$reason" >&2
fi

[[ "$guard" = Sourcing ]] || return 0

markForCUDAToolkit_ROOT() {
    local fnName=mark-for-cudatoolkit-root-hook::markForCUDAToolkit_ROOT
    echo "$fnName: Running" >&2

    mkdir -p "${prefix:?}/nix-support"
    local markerPath="$prefix/nix-support/include-in-cudatoolkit-root"
    if [[ -f "$markerPath" ]]; then
        (( "${NIX_DEBUG:-0}" >= 1 )) && echo "$fnName: $markerPath exists, skipping" >&2
        return
    fi

    # Always create the file, even if it's empty, since setup-cuda-hook relies on its existence.
    # However, only populate it if strictDeps is not set.
    touch "$markerPath"
    if [[ -z ${strictDeps-} ]]; then
        (( "${NIX_DEBUG:-0}" >= 1 )) || echo "$fnName: populating $markerPath" >&2
        echo "${pname:?}-${output:?}" > "$markerPath"
    fi
}
fixupOutputHooks+=(markForCUDAToolkit_ROOT)
