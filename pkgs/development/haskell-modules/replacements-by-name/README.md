# haskell-modules/replacements-by-name

This directory is scanned, and all `.nix` files are called in order to replace their respective packages in the `haskellPackages` set.
They're loaded after `hackage-packages.nix` but before any overrides are applied.
See [non-hackage-packages.nix](../non-hackage-packages.nix) for the implementation.

This is used for selective backports of updates, as the hackage package set won't be updated in its entirety.
