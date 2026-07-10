#!/usr/bin/env nix-shell
#!nix-shell -p cabal2nix elm2nix -i bash ../../..

# Update all cabal packages.
for subpath in 'avh4-lib' 'elm-format-lib' 'elm-format-markdown' 'elm-format-test-lib'; do
  cabal2nix --no-haddock 'https://github.com/avh4/elm-format' --revision '0.8.8' \
    --subpath $subpath > packages/ghc9_8/elm-format/${subpath}.nix
done
cabal2nix --no-haddock 'https://github.com/avh4/elm-format' --revision '0.8.8' > packages/ghc9_8/elm-format/elm-format.nix
cabal2nix 'https://github.com/ekmett/ansi-wl-pprint' --revision 'v0.6.8.1' > packages/ghc9_6/ansi-wl-pprint/default.nix

# We're building binaries from commit that npm installer is using since
# November 1st release called 0.19.1-6 in npm registry.
# These binaries are built with newer ghc version and also support Aarch64 for Linux and Darwin.
# Upstream git tag for 0.19.1 is still pointing to original commit from 2019.
cabal2nix https://github.com/elm/compiler --revision 2f6dd29258e880dbb7effd57a829a0470d8da48b > packages/ghc9_6/elm/default.nix

echo "need to manually copy registry.dat from an existing elm project"
#elm2nix snapshot > registry.dat

pushd "$(nix-build -A elmPackages.elm.src --no-out-link ../../../..)/reactor"
  elm2nix convert > $OLDPWD/packages/elm-srcs.nix
popd
