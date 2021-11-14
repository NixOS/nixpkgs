#!/usr/bin/env nix-shell
#!nix-shell -p cabal2nix elm2nix -i bash ../../..
# shellcheck shell=bash

cabal2nix https://github.com/elm/compiler --revision c9aefb6230f5e0bda03205ab0499f6e4af924495 > packages/elm.nix
echo "need to manually copy registry.dat from an existing elm project"
#elm2nix snapshot > registry.dat
pushd "$(nix-build -A elmPackages.elm.src --no-out-link ../../../..)/reactor"
  elm2nix convert > $OLDPWD/packages/elm-srcs.nix
popd
