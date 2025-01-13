#! /usr/bin/env nix-shell
#! nix-shell -p racket-minimal nix-prefetch-git nix-prefetch-github curl
#! nix-shell -i bash

set -eu -o pipefail
dir="$(dirname "$0")"
cd "$dir"

declare -a rkt_args
if test -v 1; then
    rkt_args=("$@")
else
    manifest_file=$(mktemp)
    curl -sSL https://pkgs.racket-lang.org/pkgs-all > $manifest_file
    rkt_args=("-f" "$manifest_file" "-o" "$(realpath core.json)" "main-distribution")
fi

echo "generating manifest with arguments: ${rkt_args[@]}"

racket -W warning -u specify-packages.rkt "${rkt_args[@]}"

echo "manifest successfully generated"
