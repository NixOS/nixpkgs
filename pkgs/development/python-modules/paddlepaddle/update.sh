#! /usr/bin/env nix-shell
#!nix-shell -i bash -p bash nix-update common-updater-scripts jq

set -eou pipefail

nix-update --system=x86_64-linux --url=https://github.com/PaddlePaddle/Paddle --override-filename=pkgs/development/python-modules/paddlepaddle/sources.nix --use-github-releases python313Packages.paddlepaddle || true

latestVersion=$(nix eval --raw --file . python313Packages.paddlepaddle.version)

systems=$(nix eval --json -f . python313Packages.paddlepaddle.meta.platforms | jq --raw-output '.[]')
for system in $systems; do
    for pythonPackages in "python313Packages" "python312Packages"; do
        hash=$(nix --extra-experimental-features nix-command hash convert --to sri --hash-algo sha256 $(nix-prefetch-url $(nix eval --raw --file . $pythonPackages.paddlepaddle.src.url --system "$system")))
        update-source-version $pythonPackages.paddlepaddle $latestVersion $hash --file=pkgs/development/python-modules/paddlepaddle/sources.nix --system=$system --ignore-same-version --ignore-same-hash
    done
done

for cuda in "12_6" "12_9" "13_0"; do
    for pythonPackages in "python313Packages" "python312Packages"; do
        hash=$(nix --extra-experimental-features nix-command hash convert --to sri --hash-algo sha256 $(nix-prefetch-url $(nix eval --raw --file . pkgsCuda.cudaPackages_${cuda}.pkgs.$pythonPackages.paddlepaddle.src.url --system x86_64-linux)))
        update-source-version pkgsCuda.cudaPackages_${cuda}.pkgs.$pythonPackages.paddlepaddle $latestVersion $hash --file=pkgs/development/python-modules/paddlepaddle/sources.nix --system=x86_64-linux --ignore-same-version --ignore-same-hash
    done
done
