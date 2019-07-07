#!/usr/bin/env nix-shell
#!nix-shell -p cabal2nix elm2nix -i bash ../../..

cabal2nix https://github.com/elm/compiler --revision d5cbc41aac23da463236bbc250933d037da4055a > packages/elm.nix
elm2nix snapshot > versions.dat
pushd "$(nix-build -A elmPackages.elm.src --no-out-link ../../../..)/ui/browser"
  elm2nix convert > $OLDPWD/packages/elm-srcs.nix
popd
