#!/usr/bin/env bash

prefetch () {
    expr="(import <nixpkgs> { system = \"$1\"; config.cudaSupport = $2; }).python3.pkgs.jaxlib-bin.src.url"
    url=$(NIX_PATH=.. nix-instantiate --eval -E "$expr" | jq -r)
    echo "$url"
    sha256=$(nix-prefetch-url "$url")
    nix hash to-sri --type sha256 "$sha256"
    echo
}

prefetch "x86_64-linux" "false"
prefetch "aarch64-darwin" "false"
prefetch "x86_64-darwin" "false"
prefetch "x86_64-linux" "true"
