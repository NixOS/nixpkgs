# shellcheck shell=bash

# Should we mimick cc-wrapper's "hygiene"?
[[ -z ${strictDeps-} ]] || (( "$hostOffset" < 0 )) || return 0

echo "Sourcing mark-for-cudatoolkit-root-hook" >&2

markForCUDAToolkit_ROOT() {
    mkdir -p "${prefix}/nix-support"
    [[ -f "${prefix}/nix-support/include-in-cudatoolkit-root" ]] && return
    echo "$pname-$output" > "${prefix}/nix-support/include-in-cudatoolkit-root"
}

fixupOutputHooks+=(markForCUDAToolkit_ROOT)
