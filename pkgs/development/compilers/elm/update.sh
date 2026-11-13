#!/usr/bin/env nix-shell
#!nix-shell -I nixpkgs=../../../..
#!nix-shell --pure -p nix cacert cabal2nix elm2nix nixfmt -i bash ../../../..

set -o errexit
set -o nounset

# Update all cabal packages.
for subpath in 'avh4-lib' 'elm-format-lib' 'elm-format-markdown' 'elm-format-test-lib'; do
  cabal2nix --no-haddock 'https://github.com/avh4/elm-format' --revision '0.8.8' \
    --subpath $subpath > packages/ghc9_8/elm-format/${subpath}.nix
done
cabal2nix --no-haddock 'https://github.com/avh4/elm-format' --revision '0.8.8' > packages/ghc9_8/elm-format/elm-format.nix
cabal2nix 'https://github.com/ekmett/ansi-wl-pprint' --revision 'v0.6.8.1' > packages/ghc9_8/ansi-wl-pprint/default.nix

# We're building binaries from commit corresponding to https://github.com/elm/compiler/releases/tag/0.19.2.
# These binaries are built with newer ghc version and also support Aarch64 for Linux and Darwin.
cabal2nix https://github.com/elm/compiler --revision 48befde196cbcbdf459114e36c02b52c49b58050 > packages/ghc9_8/elm/default.nix

echo "need to manually copy registry.dat from an existing elm project"
#elm2nix snapshot > registry.dat

pushd "$(nix-build -A elmPackages.elm.src --no-out-link ../../../..)/reactor"
  elm2nix convert > $OLDPWD/packages/elm-srcs.nix
popd

# cabal2nix, elm2nix, etc. may not respect nixpkgs formatting rules
nixfmt .
