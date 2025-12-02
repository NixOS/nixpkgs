# Elm packages

Mixtures of useful Elm lang tooling containing both Haskell and Node.js based utilities.

## Upgrades

Haskell parts of the ecosystem are using [cabal2nix](https://github.com/NixOS/cabal2nix).
Please refer to [nix documentation](https://nixos.org/nixpkgs/manual/#how-to-create-nix-builds-for-your-own-private-haskell-packages)
and [cabal2nix readme](https://github.com/NixOS/cabal2nix#readme) for more information. Elm-format [update scripts](https://github.com/avh4/elm-format/tree/master/package/nix)
is part of its repository.

Node dependencies are defined with [`buildNpmPackage`](https://nixos.org/manual/nixpkgs/stable/#javascript-buildNpmPackage).
