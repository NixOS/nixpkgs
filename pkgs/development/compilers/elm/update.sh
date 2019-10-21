#!/usr/bin/env nix-shell
#!nix-shell -p cabal2nix elm2nix -i bash ../../..

cabal2nix https://github.com/elm/compiler --revision c9aefb6230f5e0bda03205ab0499f6e4af924495 > packages/elm.nix
elm2nix snapshot > versions.dat
pushd "$(nix-build -A elmPackages.elm.src --no-out-link ../../../..)/reactor"
  elm2nix convert > $OLDPWD/packages/elm-srcs.nix
popd
