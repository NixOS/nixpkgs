# overrides

A nested directory structure provided to [`lib.filesystem.packagesFromDirectoryRecursive`](https://github.com/NixOS/nixpkgs/blob/56cfc87a73f089e68dfe7f73cb67742dd0f34ee3/lib/filesystem.nix#L244).

Top-level directory names must be valid redistributable names. For a list, see [`redistNames` in data.nix](../new-modules/data.nix).

Within each directory are files named after the package they override. The contents of these files are functions provided to `callPackage`, and then given to the corresponding package's `overrideAttrs` attribute. They must return a function, otherwise `callPackage` will change the `override` attribute on the returned attribute set, breaking further overrides.
