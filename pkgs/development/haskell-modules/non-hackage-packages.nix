# EXTRA HASKELL PACKAGES NOT ON HACKAGE
#
# This file should only contain packages that are not in ./hackage-packages.nix.
# Attributes in this set should be nothing more than a callPackage call.
# Overrides to these packages should go to either configuration-nix.nix,
# configuration-common.nix or to one of the compiler specific configuration
# files.
self: super: {

  multi-ghc-travis = throw ("haskellPackages.multi-ghc-travis has been renamed"
    + "to haskell-ci, which is now on hackage");

  # https://github.com/channable/vaultenv/issues/1
  vaultenv = self.callPackage ../tools/haskell/vaultenv { };
}
