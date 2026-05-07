#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl common-updater-scripts

set -euo pipefail

version=$(curl -s "https://typora.io/#linux" | sed -E -n 's/.*typora_([0-9.]+)_amd64.*/\1/p')

linux_amd64_hash=$(nix-hash --type sha256 --to-sri $(nix-prefetch-url https://download.typora.io/linux/typora_${version}_amd64.deb))
update-source-version typora $version $linux_amd64_hash --system=x86_64-linux --ignore-same-version

linux_arm64_hash=$(nix-hash --type sha256 --to-sri $(nix-prefetch-url https://download.typora.io/linux/typora_${version}_arm64.deb))
update-source-version typora $version $linux_arm64_hash --system=aarch64-linux --ignore-same-version

darwin_arm64_hash=$(nix-hash --type sha256 --to-sri $(nix-prefetch-url https://download.typora.io/mac/Typora-${version}.dmg))
update-source-version typora $version $darwin_arm64_hash --system=aarch64-darwin --ignore-same-version
