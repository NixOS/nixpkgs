#!/usr/bin/env nix-shell
#!nix-shell -i bash -p nix-update gnugrep gnused zig_0_17

set -euo pipefail

nix-update turbo-unwrapped

src="$(nix-build --no-out-link -A turbo-unwrapped.src)"
rev=$(grep "const GHOSTTY_COMMIT" "$src/crates/libghostty-vt-sys/build.rs" | cut -d '"' -f2)
sed -i -E "s|\brev = \".*\";|rev = \"$rev\";|" "pkgs/by-name/tu/turbo-unwrapped/package.nix"

nix-update turbo-unwrapped --no-src --custom-dep ghostty-src

ghostty_src="$(nix-build --no-out-link -A turbo-unwrapped.ghostty-src)"
nix --extra-experimental-features 'nix-command flakes' run github:jcollie/zon2nix#zon2nix --  --17 --nix=pkgs/by-name/tu/turbo-unwrapped/deps.nix "$ghostty_src/build.zig.zon"
