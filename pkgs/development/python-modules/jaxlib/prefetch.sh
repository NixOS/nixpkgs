<<<<<<< HEAD
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
=======
version="$1"
nix hash to-sri --type sha256 "$(nix-prefetch-url https://storage.googleapis.com/jax-releases/nocuda/jaxlib-${version}-cp39-none-manylinux2010_x86_64.whl)"
nix hash to-sri --type sha256 "$(nix-prefetch-url https://storage.googleapis.com/jax-releases/nocuda/jaxlib-${version}-cp310-none-manylinux2010_x86_64.whl)"
nix hash to-sri --type sha256 "$(nix-prefetch-url https://storage.googleapis.com/jax-releases/cuda11/jaxlib-${version}+cuda11.cudnn805-cp39-none-manylinux2010_x86_64.whl)"
nix hash to-sri --type sha256 "$(nix-prefetch-url https://storage.googleapis.com/jax-releases/cuda11/jaxlib-${version}+cuda11.cudnn82-cp39-none-manylinux2010_x86_64.whl)"
nix hash to-sri --type sha256 "$(nix-prefetch-url https://storage.googleapis.com/jax-releases/cuda11/jaxlib-${version}+cuda11.cudnn805-cp310-none-manylinux2010_x86_64.whl)"
nix hash to-sri --type sha256 "$(nix-prefetch-url https://storage.googleapis.com/jax-releases/cuda11/jaxlib-${version}+cuda11.cudnn82-cp310-none-manylinux2010_x86_64.whl)"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
