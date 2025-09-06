{ pkgs, haskellLib }:

let
  inherit (pkgs) lib;
  inherit (lib.strings) hasSuffix removeSuffix;

  pathsByName = lib.concatMapAttrs (
    name: type:
    lib.optionalAttrs (type == "regular" && hasSuffix ".nix" name) {
      ${removeSuffix ".nix" name} = ./replacements-by-name + "/${name}";
    }
  ) (builtins.readDir ./replacements-by-name);
in

# EXTRA HASKELL PACKAGES NOT ON HACKAGE
#
# This file should only contain packages that are not in ./hackage-packages.nix.
# Attributes in this set should be nothing more than a callPackage call.
# Overrides to these packages should go to either configuration-nix.nix,
# configuration-common.nix or to one of the compiler specific configuration
# files.
self: super:
{

  changelog-d = self.callPackage ../misc/haskell/changelog-d { };

  dconf2nix = self.callPackage ../tools/haskell/dconf2nix/dconf2nix.nix { };

  # Used by maintainers/scripts/regenerate-hackage-packages.sh, and generated
  # from the latest master instead of the current version on Hackage.
  cabal2nix-unstable = self.callPackage ./cabal2nix-unstable.nix { };

  ghc-settings-edit = self.callPackage ../tools/haskell/ghc-settings-edit { };

  # https://github.com/channable/vaultenv/issues/1
  vaultenv = self.callPackage ../tools/haskell/vaultenv { };

  # spago is not released to Hackage.
  # https://github.com/spacchetti/spago/issues/512
  spago = self.callPackage ../tools/purescript/spago/spago.nix { };

  # Unofficial fork until PRs are merged https://github.com/pcapriotti/optparse-applicative/pulls/roberth
  # cabal2nix --maintainer roberth https://github.com/hercules-ci/optparse-applicative.git > pkgs/development/misc/haskell/hercules-ci-optparse-applicative.nix
  hercules-ci-optparse-applicative =
    self.callPackage ../misc/haskell/hercules-ci-optparse-applicative.nix
      { };

}
// lib.mapAttrs (_name: path: self.callPackage path { }) pathsByName
