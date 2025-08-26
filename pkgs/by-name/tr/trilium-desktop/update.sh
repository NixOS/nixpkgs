#!/usr/bin/env nix-shell
#!nix-shell -i bash -p coreutils curl jq
set -euo pipefail

cd $(dirname "${BASH_SOURCE[0]}")

setKV () {
    sed -i "s|$2 = \".*\"|$2 = \"${3:-}\"|" $1
}

version=$(curl -s --show-error "https://api.github.com/repos/TriliumNext/Trilium/releases/latest" | jq -r '.tag_name' | tail -c +2)
setKV ./package.nix version $version

# Update desktop application
sha256_linux64=$(nix store prefetch-file --json --hash-type sha256 https://github.com/TriliumNext/Trilium/releases/download/v${version}/TriliumNotes-v${version}-linux-x64.zip | jq -r .hash)
sha256_linux64_arm=$(nix store prefetch-file --json --hash-type sha256 https://github.com/TriliumNext/Trilium/releases/download/v${version}/TriliumNotes-v${version}-linux-arm64.zip | jq -r .hash)
sha256_darwin64=$(nix store prefetch-file --json --hash-type sha256 https://github.com/TriliumNext/Trilium/releases/download/v${version}/TriliumNotes-v${version}-macos-x64.zip | jq -r .hash)
sha256_darwin64_arm=$(nix store prefetch-file --json --hash-type sha256 https://github.com/TriliumNext/Trilium/releases/download/v${version}/TriliumNotes-v${version}-macos-arm64.zip | jq -r .hash)
setKV ./package.nix x86_64-linux.hash $sha256_linux64
setKV ./package.nix aarch64-linux.hash $sha256_linux64_arm
setKV ./package.nix x86_64-darwin.hash $sha256_darwin64
setKV ./package.nix aarch64-darwin.hash $sha256_darwin64_arm

# Update server
sha256_linux64_server=$(nix store prefetch-file --json --hash-type sha256 https://github.com/TriliumNext/Trilium/releases/download/v${version}/TriliumNotes-Server-v${version}-linux-x64.tar.xz | jq -r .hash)
sha256_linux64_server_arm=$(nix store prefetch-file --json --hash-type sha256 https://github.com/TriliumNext/Trilium/releases/download/v${version}/TriliumNotes-Server-v${version}-linux-arm64.tar.xz | jq -r .hash)
setKV ../trilium-server/package.nix version $version
setKV ../trilium-server/package.nix serverSource_x64.hash $sha256_linux64_server
setKV ../trilium-server/package.nix serverSource_arm64.hash $sha256_linux64_server_arm
