#!/usr/bin/env nix-shell
#!nix-shell -p cabal2nix elm2nix -i bash ../../..

cabal2nix https://github.com/elm/compiler --revision 2f6dd29258e880dbb7effd57a829a0470d8da48b > packages/elm.nix
echo "need to manually copy registry.dat from an existing elm project"
#elm2nix snapshot > registry.dat
pushd "$(nix-build -A elmPackages.elm.src --no-out-link ../../../..)/reactor"
  elm2nix convert > $OLDPWD/packages/elm-srcs.nix
popd
