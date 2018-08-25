# EXTRA HASKELL PACKAGES NOT ON HACKAGE
#
# This file should only contain packages that are not in ./hackage-packages.nix.
# Attributes in this set should be nothing more than a callPackage call.
# Overrides to these packages should go to either configuration-nix.nix,
# configuration-common.nix or to one of the compiler specific configuration
# files.
self: super: {
  multi-ghc-travis = self.callPackage ../tools/haskell/multi-ghc-travis { };

  vaultenv = self.callPackage ../tools/haskell/vaultenv { };

  futhark = self.callPackage ../compilers/futhark { };
}
