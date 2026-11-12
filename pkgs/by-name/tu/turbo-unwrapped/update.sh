#!/usr/bin/env nix-shell
#!nix-shell -i bash -p nix-update gnugrep gnused

set -euo pipefail

nix-update turbo-unwrapped

src="$(nix-build --no-out-link -A turbo-unwrapped.src)"
rev=$(grep "const GHOSTTY_COMMIT" "$src/crates/libghostty-vt-sys/build.rs" | cut -d '"' -f2)
sed -i -E "s|\brev = \".*\";|rev = \"$rev\";|" "pkgs/by-name/tu/turbo-unwrapped/package.nix"

nix-update turbo-unwrapped --no-src --custom-dep ghostty-src --custom-dep ghostty-deps
