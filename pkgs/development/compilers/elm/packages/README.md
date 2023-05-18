# Elm packages

Mixtures of useful Elm lang tooling containing both Haskell and Node.js based utilities.

## Upgrades

Haskell parts of the ecosystem are using [cabal2nix](https://github.com/NixOS/cabal2nix).
Please refer to [nix documentation](https://nixos.org/nixpkgs/manual/#how-to-create-nix-builds-for-your-own-private-haskell-packages)
and [cabal2nix readme](https://github.com/NixOS/cabal2nix#readme) for more information. Elm-format [update scripts](https://github.com/avh4/elm-format/tree/master/package/nix)
is part of its repository.

Node dependencies are defined in [node-packages.json](node-packages.json).
[Node2nix](https://github.com/svanderburg/node2nix) is used for generating nix expression
from this file. Use [generate-node-packages.sh](generate-node-packages.sh) for updates of nix expressions.

## Binwrap Patch

Some node packages might use [binwrap](https://github.com/avh4/binwrap) typically for installing
[elmi-to-json](https://github.com/stoeffel/elmi-to-json). Binwrap is not compatible with nix.
To overcome issues with those packages apply [patch-binwrap.nix](patch-binwrap.nix) which essentially does 2 things.

1. It replaces binwrap scripts with noop shell scripts
2. It uses nix for installing the binaries to expected location in `node_modules`

Example usage be found in `elm/default.nix`.
