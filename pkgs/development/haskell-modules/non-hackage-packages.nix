# EXTRA HASKELL PACKAGES NOT ON HACKAGE
#
# This file should only contain packages that are not in ./hackage-packages.nix.
# Attributes in this set should be nothing more than a callPackage call.
# Overrides to these packages should go to either configuration-nix.nix,
# configuration-common.nix or to one of the compiler specific configuration
# files.
self: super: {

  changelog-d = self.callPackage ../misc/haskell/changelog-d {};

  dconf2nix = self.callPackage ../tools/haskell/dconf2nix/dconf2nix.nix { };

  # Used by maintainers/scripts/regenerate-hackage-packages.sh, and generated
  # from the latest master instead of the current version on Hackage.
  cabal2nix-unstable = self.callPackage ./cabal2nix-unstable.nix { };

  # https://github.com/channable/vaultenv/issues/1
  vaultenv = self.callPackage ../tools/haskell/vaultenv { };

  # spago is not released to Hackage.
  # https://github.com/spacchetti/spago/issues/512
  spago = self.callPackage ../tools/purescript/spago/spago.nix { };

  nix-linter = self.callPackage ../../development/tools/analysis/nix-linter { };

  # hasura graphql-engine is not released to hackage.
  # https://github.com/hasura/graphql-engine/issues/7391
  ci-info = self.callPackage ../misc/haskell/hasura/ci-info.nix {};
  pg-client = self.callPackage ../misc/haskell/hasura/pg-client.nix {};
  graphql-parser = self.callPackage ../misc/haskell/hasura/graphql-parser.nix {};
  graphql-engine = self.callPackage ../misc/haskell/hasura/graphql-engine.nix {};
  kriti-lang = self.callPackage ../misc/haskell/hasura/kriti-lang.nix {};
  hasura-resource-pool = self.callPackage ../misc/haskell/hasura/pool.nix {};
  hasura-ekg-core = self.callPackage ../misc/haskell/hasura/ekg-core.nix {};
  hasura-ekg-json = self.callPackage ../misc/haskell/hasura/ekg-json.nix {};

  # Unofficial fork until PRs are merged https://github.com/pcapriotti/optparse-applicative/pulls/roberth
  # cabal2nix --maintainer roberth https://github.com/hercules-ci/optparse-applicative.git > pkgs/development/misc/haskell/hercules-ci-optparse-applicative.nix
  hercules-ci-optparse-applicative = self.callPackage ../misc/haskell/hercules-ci-optparse-applicative.nix {};

}
