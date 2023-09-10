# shellcheck shell=bash

markForCUDAToolkit_ROOT() {
    mkdir -p "${prefix}/nix-support"
    touch "${prefix}/nix-support/include-in-cudatoolkit-root"
}

fixupOutputHooks+=(markForCUDAToolkit_ROOT)
