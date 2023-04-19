#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq nix-update

set -euf -o pipefail

NEW_VERSION=$(curl https://vulkan.lunarg.com/sdk/latest/linux.json | jq -r '.linux')

VULKAN_SDK_PACKAGES=(
    "vulkan-headers"
    "spirv-headers"
    "glslang"
    "vulkan-loader"
    "spirv-tools"
    "spirv-cross"
    "vulkan-validation-layers"
    "vulkan-tools"
    "vulkan-tools-lunarg"
    "vulkan-extension-layer"
)

for P in "${VULKAN_SDK_PACKAGES[@]}"; do
    nix-update "$P" --version "$NEW_VERSION" --commit
done
