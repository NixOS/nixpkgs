#!/usr/bin/env nix-shell
#!nix-shell -i bash -p nix-update

set -euf -o pipefail

V_PACKAGES=(
    "vulkan-headers"
    "vulkan-loader"
    "vulkan-validation-layers"
    "vulkan-tools"
    "vulkan-tools-lunarg"
    "vulkan-extension-layer"
    "vulkan-utility-libraries"
)

SDK_PACKAGES=(
    "spirv-headers"
    "spirv-cross"
    "spirv-tools"
)

nix-update glslang --version-regex '(\d+\.\d+\.\d+)' --commit

for P in "${V_PACKAGES[@]}"; do
    nix-update "$P" --version-regex "(?:v)(.*)" --commit
done

for P in "${SDK_PACKAGES[@]}"; do
    nix-update "$P" --version-regex "(?:sdk-)(.*)" --commit
done
