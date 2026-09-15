# ARM-SPECIFIC OVERRIDES FOR THE HASKELL PACKAGE SET IN NIXPKGS
#
# This extension is applied to all haskell package sets in nixpkgs if
# `stdenv.hostPlatform.isAarch` to apply arm specific workarounds or
# fixes.
#
# The file is split into three parts:
#
# * Overrides that are applied for all arm platforms
# * Overrides for aarch32 platforms
# * Overrides for aarch64 platforms
#
# This may be extended in the future to also include compiler-
# specific sections as compiler and linker related bugs may
# get fixed subsequently.
#
# When adding new overrides, try to research which section they
# belong into. Most likely we'll be favouring aarch64 overrides
# in practice since that is the only platform we can test on
# Hydra. Also take care to group overrides by the issue they
# solve, so refactors and updates to this file are less tedious.
{ pkgs, haskellLib }:

let
  inherit (pkgs) lib;
in

with haskellLib;

self: super:
{
  # COMMON ARM OVERRIDES

  # moved here from configuration-common.nix, no reason given.
  servant-docs = dontCheck super.servant-docs;
  swagger2 = dontHaddock (dontCheck super.swagger2);

  # Similar to https://ghc.haskell.org/trac/ghc/ticket/13062
  happy = dontCheck super.happy;

  # add arm specific library
  wiringPi = overrideCabal (
    {
      librarySystemDepends ? [ ],
      ...
    }:
    {
      librarySystemDepends = librarySystemDepends ++ [ pkgs.wiringpi ];
    }
  ) super.wiringPi;

}
// lib.optionalAttrs pkgs.stdenv.hostPlatform.isAarch64 {
  # AARCH64-SPECIFIC OVERRIDES

  # Doctests fail on aarch64 due to a GHCi linking bug
  # https://gitlab.haskell.org/ghc/ghc/-/issues/15275#note_295437
  # TODO: figure out if needed on aarch32 as well
  C-structs = dontCheck super.C-structs;
  Jikka = dontCheck super.Jikka;
  ad = dontCheck super.ad;
  autoapply = dontCheck super.autoapply;
  construct = dontCheck super.construct;
  flight-kml = dontCheck super.flight-kml;
  grammatical-parsers = dontCheck super.grammatical-parsers;
  groupBy = dontCheck super.groupBy;
  hgeometry = dontCheck super.hgeometry;
  hhp = dontCheck super.hhp;
  hsakamai = dontCheck super.hsakamai;
  hw-fingertree-strict = dontCheck super.hw-fingertree-strict;
  hw-packed-vector = dontCheck super.hw-packed-vector;
  hw-xml = dontCheck super.hw-xml;
  meep = dontCheck super.meep;
  orbits = dontCheck super.orbits;
  rank2classes = dontCheck super.rank2classes;
  static = dontCheck super.static;
  strict-writer = dontCheck super.strict-writer;
  termonad = dontCheck super.termonad;
  twiml = dontCheck super.twiml;
  twitter-conduit = dontCheck super.twitter-conduit;
  validationt = dontCheck super.validationt;
  vgrep = dontCheck super.vgrep;
  vulkan-utils = dontCheck super.vulkan-utils;
  yaml-combinators = dontCheck super.yaml-combinators;

  # We disable profiling on aarch64, so tests naturally fail
  ghc-prof = dontCheck super.ghc-prof;

  # Similar RTS issue in test suite:
  # rts/linker/elf_reloc_aarch64.c:98: encodeAddendAarch64: Assertion `isInt64(21+12, addend)' failed.
  # These still fail sporadically on ghc 9.2
}
// lib.optionalAttrs pkgs.stdenv.hostPlatform.isAarch32 {
  # AARCH32-SPECIFIC OVERRIDES

  # KAT/ECB/D2 test segfaults on armv7l
  # https://github.com/haskell-crypto/cryptonite/issues/367 krank:ignore-line
  cryptonite = dontCheck super.cryptonite;
}
// lib.optionalAttrs (with pkgs.stdenv.hostPlatform; isAarch && isAndroid) {
  # android is not currently allowed as 'supported-platforms' by hackage2nix
  android-activity = unmarkBroken super.android-activity;
}
// lib.optionalAttrs (with pkgs.stdenv.hostPlatform; !isDarwin) {
  # 2026-01-09: RNG tests that need rng-instruction support fail on NixOS's
  #             aarch64-linux build infrastructure
  botan-low = overrideCabal (drv: {
    testFlags =
      drv.testFlags or [ ]
      ++ (lib.concatMap (x: [ "--skip" ] ++ [ x ]) [
        # botan-low-rng-tests
        "/rdrand/rngInit/"
        "/rdrand/rngGet/"
        "/rdrand/rngReseed/"
        "/rdrand/rngReseedFromRNGCtx/"
        "/rdrand/rngAddEntropy/"
      ]);
  }) super.botan-low;
}
