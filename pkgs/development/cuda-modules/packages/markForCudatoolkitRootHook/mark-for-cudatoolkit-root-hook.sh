# shellcheck shell=bash

(( ${hostOffset:?} == -1 && ${targetOffset:?} == 0)) || return 0

echo "Sourcing mark-for-cudatoolkit-root-hook" >&2

markForCUDAToolkit_ROOT() {
    mkdir -p "${prefix:?}/nix-support"
    local markerPath="$prefix/nix-support/include-in-cudatoolkit-root"

    # Return early if the file already exists.
    [[ -f "$markerPath" ]] && return 0

    # Always create the file, even if it's empty, since setup-cuda-hook relies on its existence.
    # However, only populate it if strictDeps is not set.
    touch "$markerPath"

    # Return early if strictDeps is set.
    [[ -n "${strictDeps-}" ]] && return 0

    # Populate the file with the package name and output.
    echo "${pname:?}-${output:?}" > "$markerPath"
}

fixupOutputHooks+=(markForCUDAToolkit_ROOT)
