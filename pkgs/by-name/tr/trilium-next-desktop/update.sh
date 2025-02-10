#!/usr/bin/env nix-shell
#!nix-shell -i bash -p coreutils curl jq
set -euo pipefail

cd $(dirname "${BASH_SOURCE[0]}")

setKV () {
    sed -i "s|$2 = \".*\"|$2 = \"${3:-}\"|" $1
}

version=$(curl -s --show-error "https://api.github.com/repos/TriliumNext/Notes/releases/latest" | jq -r '.tag_name' | tail -c +2)
setKV ./package.nix version $version

# Update desktop application
sha256_linux64=$(nix-prefetch-url --quiet https://github.com/TriliumNext/Notes/releases/download/v${version}/TriliumNextNotes-v${version}-linux-x64.zip)
sha256_darwin64=$(nix-prefetch-url --quiet https://github.com/TriliumNext/Notes/releases/download/v${version}/TriliumNextNotes-v${version}-macos-x64.zip)
setKV ./package.nix linuxSource.sha256 $sha256_linux64
setKV ./package.nix darwinSource.sha256 $sha256_darwin64

# Update server
sha256_linux64_server=$(nix-prefetch-url --quiet https://github.com/TriliumNext/Notes/releases/download/v${version}/TriliumNextNotes-linux-x64-v${version}.tar.xz)
sha256_linux64_server_arm=$(nix-prefetch-url --quiet https://github.com/TriliumNext/Notes/releases/download/v${version}/TriliumNextNotes-linux-arm64-v${version}.tar.xz)
setKV ../trilium-next-server/package.nix version $version
setKV ../trilium-next-server/package.nix serverSource_x64.sha256 $sha256_linux64_server
setKV ../trilium-next-server/package.nix serverSource_arm64.sha256 $sha256_linux64_server_arm
