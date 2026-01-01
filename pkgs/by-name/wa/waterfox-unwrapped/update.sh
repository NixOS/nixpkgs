#!/usr/bin/env nix-shell
#!nix-shell -i bash -p nix-update gnused

set -euo pipefail

pkgdir="pkgs/by-name/wa/waterfox-unwrapped"

nix-update waterfox-unwrapped --src-only --override-filename "$pkgdir/package.nix"

src="$(nix-build --no-out-link -A waterfox-unwrapped.src)"

firefoxVersion=$(<"$src/browser/config/version.txt")
sed -i -E "s|\bversion = \".*\";|version = \"$firefoxVersion\";|" "$pkgdir/package.nix"
