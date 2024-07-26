#!/usr/bin/env nix-shell
#!nix-shell -p cabal2nix elm2nix -i bash ../../..

# We're building binaries from commit that npm installer is using since
# November 1st release called 0.19.1-6 in npm registry.
# These binaries are built with newer ghc version and also support Aarch64 for Linux and Darwin.
# Upstream git tag for 0.19.1 is still pointing to original commit from 2019.
cabal2nix https://github.com/elm/compiler --revision 2f6dd29258e880dbb7effd57a829a0470d8da48b > packages/elm.nix

echo "need to manually copy registry.dat from an existing elm project"
#elm2nix snapshot > registry.dat

pushd "$(nix-build -A elmPackages.elm.src --no-out-link ../../../..)/reactor"
  elm2nix convert > $OLDPWD/packages/elm-srcs.nix
popd
