#!/usr/bin/env nix-shell
#!nix-shell -i bash -p nix-update

set -euf -o pipefail

SDK_PACKAGES=(
    "vulkan-headers"
    "vulkan-loader"
    "vulkan-validation-layers"
    "vulkan-tools"
    "vulkan-tools-lunarg"
    "vulkan-extension-layer"
    "vulkan-utility-libraries"
    "spirv-headers"
    "spirv-cross"
    "spirv-tools"
)

nix-update glslang --version-regex '(\d+\.\d+\.\d+)' --commit

for P in "${SDK_PACKAGES[@]}"; do
    nix-update "$P" --version-regex "(?:vulkan-sdk-)(.*)" --commit
done
