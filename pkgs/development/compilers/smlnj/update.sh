#!/usr/bin/env nix-shell
#!nix-shell -I nixpkgs=./. -i bash -p bash curl nix-prefetch jq
# shellcheck shell=bash

set -euo pipefail

dir="$(dirname "$0")"
url="https://smlnj.cs.uchicago.edu/dist/working/"
hashfile="$dir/hashes.json"
nixfile="$dir/default.nix"

version="$(curl --silent "$url" \
    | sed -n 's:.*<b>\([0-9]\{3\}\.[0-9.-]\+\)</b>.*:\1:p' \
    | head -n1)"

echo "Latest SML/NJ release: $version"

if [[ -e "$hashfile" ]]; then
    old_version="$(jq -r .version "$hashfile")"
    if [[ $old_version = "$version" ]]; then
        echo "Package is already up-to-date, skipping"
        exit 0
    fi
    echo "Upgrading from $old_version to $version"
else
    echo "Generating hashes for $version"
fi

files=(
    boot.amd64-unix.tgz boot.x86-unix.tgz
    config.tgz cm.tgz compiler.tgz runtime.tgz system.tgz MLRISC.tgz
    smlnj-lib.tgz old-basis.tgz ckit.tgz nlffi.tgz cml.tgz eXene.tgz ml-lpt.tgz
    ml-lex.tgz ml-yacc.tgz ml-burg.tgz pgraph.tgz trace-debug-profile.tgz
    heap2asm.tgz smlnj-c.tgz doc.tgz asdl.tgz
)

tmpdir="$(mktemp --directory)"
trap 'rm -rf -- "$tmpdir"' EXIT

declare -a pids=()

for file in "${files[@]}"; do
    nix-prefetch --silent fetchurl --url "$url/$version/$file" > "$tmpdir/$file" &
    pids+=($!)
done

for pid in "${pids[@]}"; do
    wait "$pid"
done

printf '{\n' > "$hashfile"
for file in "${files[@]}"; do
    printf '  "%s": "%s",\n' "$file" "$(cat "$tmpdir/$file")" >> "$hashfile"
done
printf '  "version": "%s"\n' "$version" >> "$hashfile"
printf '}\n' >> "$hashfile"

sed --in-place 's:version = "[0-9.]\+";:version = "'"$version"'";:' "$nixfile"

echo "Done"
