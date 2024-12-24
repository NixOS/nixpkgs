#! /usr/bin/env nix-shell
#! nix-shell -i sh -p jq

prefetch () {
    expr="(import <nixpkgs> { system = \"$2\"; config.cudaSupport = $3; }).python$1.pkgs.jaxlib-bin.src.url"
    url=$(NIX_PATH=.. nix-instantiate --eval -E "$expr" | jq -r)
    echo "$url"
    sha256=$(nix-prefetch-url "$url")
    nix hash to-sri --type sha256 "$sha256"
    echo
}

for py in "39" "310" "311" "312"; do
    prefetch "$py" "x86_64-linux" "false"
    prefetch "$py" "aarch64-darwin" "false"
    prefetch "$py" "x86_64-darwin" "false"
    prefetch "$py" "x86_64-linux" "true"
done
