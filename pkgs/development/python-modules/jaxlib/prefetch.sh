#! /usr/bin/env nix-shell
#! nix-shell -i sh -p jq

prefetch() {
    expr="(import <nixpkgs> { system = \"$2\"; config.cudaSupport = true; }).python$1.pkgs.$3.src.url"
    url=$(NIX_PATH=.. nix-instantiate --eval -E "$expr" | jq -r)
    echo "$url"
    sha256=$(nix-prefetch-url "$url")
    nix --extra-experimental-features nix-command hash convert --to sri --hash-algo sha256 "$sha256"
    echo
}

for py in "310" "311" "312" "313"; do
    prefetch "$py" "x86_64-linux" "jaxlib-bin"
    prefetch "$py" "aarch64-linux" "jaxlib-bin"
    prefetch "$py" "aarch64-darwin" "jaxlib-bin"
    prefetch "$py" "x86_64-linux" "jax-cuda12-plugin"
    prefetch "$py" "aarch64-linux" "jax-cuda12-plugin"
done

for arch in "x86_64-linux" "aarch64-linux"; do
    prefetch "312" "$arch" "jax-cuda12-pjrt"
done
