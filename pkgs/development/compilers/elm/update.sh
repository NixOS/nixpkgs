cabal2nix https://github.com/elm/compiler --revision  32059a289d27e303fa1665e9ada0a52eb688f302 > packages/elm.nix
cabal2nix --no-check cabal://indents-0.3.3 > packages/indents.nix
cabal2nix --no-haddock --no-check --jailbreak --revision refs/tags/0.8.0 http://github.com/avh4/elm-format > packages/elm-format.nix
