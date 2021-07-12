# EXTRA HASKELL PACKAGES NOT ON HACKAGE
#
# This file should only contain packages that are not in ./hackage-packages.nix.
# Attributes in this set should be nothing more than a callPackage call.
# Overrides to these packages should go to either configuration-nix.nix,
# configuration-common.nix or to one of the compiler specific configuration
# files.
self: super: {

  dconf2nix = self.callPackage ../tools/haskell/dconf2nix/dconf2nix.nix { };

  ldgallery-compiler = self.callPackage ../../tools/graphics/ldgallery/compiler { };

  # Used by maintainers/scripts/regenerate-hackage-packages.sh, and generated
  # from the latest master instead of the current version on Hackage.
  cabal2nix-unstable = self.callPackage ./cabal2nix-unstable.nix { };

  # https://github.com/channable/vaultenv/issues/1
  vaultenv = self.callPackage ../tools/haskell/vaultenv { };

  # spago is not released to Hackage.
  # https://github.com/spacchetti/spago/issues/512
  spago = self.callPackage ../tools/purescript/spago/spago.nix { };

  nix-linter = self.callPackage ../../development/tools/analysis/nix-linter { };

  nix-output-monitor = self.callPackage ../../tools/nix/nix-output-monitor { };

  # cabal2nix --revision <rev> https://github.com/hasura/ci-info-hs.git
  ci-info = self.callPackage ../misc/haskell/hasura/ci-info {};
  # cabal2nix --revision <rev> https://github.com/hasura/pg-client-hs.git
  pg-client = self.callPackage ../misc/haskell/hasura/pg-client {};
  # cabal2nix --revision <rev> https://github.com/hasura/graphql-parser-hs.git
  graphql-parser = self.callPackage ../misc/haskell/hasura/graphql-parser {};
  # cabal2nix  --subpath server --maintainer offline --no-check --revision 1.2.1 https://github.com/hasura/graphql-engine.git
  graphql-engine = self.callPackage ../misc/haskell/hasura/graphql-engine {};

  # Unofficial fork until PRs are merged https://github.com/pcapriotti/optparse-applicative/pulls/roberth
  # cabal2nix --maintainer roberth https://github.com/hercules-ci/optparse-applicative.git > pkgs/development/misc/haskell/hercules-ci-optparse-applicative.nix
  hercules-ci-optparse-applicative = self.callPackage ../misc/haskell/hercules-ci-optparse-applicative.nix {};
}
