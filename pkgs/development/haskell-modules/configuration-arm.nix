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
  BNFC = dontCheck super.BNFC;
  C-structs = dontCheck super.C-structs;
  Chart-tests = dontCheck super.Chart-tests;
  Jikka = dontCheck super.Jikka;
  accelerate = dontCheck super.accelerate;
  ad = dontCheck super.ad;
  autoapply = dontCheck super.autoapply;
  construct = dontCheck super.construct;
  exact-real = dontCheck super.exact-real;
  flight-kml = dontCheck super.flight-kml;
  focuslist = dontCheck super.focuslist;
  grammatical-parsers = dontCheck super.grammatical-parsers;
  greskell = dontCheck super.greskell;
  groupBy = dontCheck super.groupBy;
  haskell-time-range = dontCheck super.haskell-time-range;
  headroom = dontCheck super.headroom;
  hgeometry = dontCheck super.hgeometry;
  hhp = dontCheck super.hhp;
  hsakamai = dontCheck super.hsakamai;
  hsemail-ns = dontCheck super.hsemail-ns;
  html-validator-cli = dontCheck super.html-validator-cli;
  hw-fingertree-strict = dontCheck super.hw-fingertree-strict;
  hw-packed-vector = dontCheck super.hw-packed-vector;
  hw-prim = dontCheck super.hw-prim;
  hw-xml = dontCheck super.hw-xml;
  language-nix = dontCheck super.language-nix;
  lens-regex = dontCheck super.lens-regex;
  meep = dontCheck super.meep;
  openapi3 = dontCheck super.openapi3;
  orbits = dontCheck super.orbits;
  ranged-list = dontCheck super.ranged-list;
  rank2classes = dontCheck super.rank2classes;
  schedule = dontCheck super.schedule;
  static = dontCheck super.static;
  strict-writer = dontCheck super.strict-writer;
  termonad = dontCheck super.termonad;
  trifecta = dontCheck super.trifecta;
  twiml = dontCheck super.twiml;
  twitter-conduit = dontCheck super.twitter-conduit;
  validationt = dontCheck super.validationt;
  vgrep = dontCheck super.vgrep;
  vinyl = dontCheck super.vinyl;
  vulkan-utils = dontCheck super.vulkan-utils;
  xml-html-qq = dontCheck super.xml-html-qq;
  yaml-combinators = dontCheck super.yaml-combinators;
  yesod-paginator = dontCheck super.yesod-paginator;

  # https://github.com/ekmett/half/issues/35
  half = dontCheck super.half;

  # We disable profiling on aarch64, so tests naturally fail
  ghc-prof = dontCheck super.ghc-prof;

  # Similar RTS issue in test suite:
  # rts/linker/elf_reloc_aarch64.c:98: encodeAddendAarch64: Assertion `isInt64(21+12, addend)' failed.
  # These still fail sporadically on ghc 9.2
}
// lib.optionalAttrs pkgs.stdenv.hostPlatform.isAarch32 {
  # AARCH32-SPECIFIC OVERRIDES

  # KAT/ECB/D2 test segfaults on armv7l
  # https://github.com/haskell-crypto/cryptonite/issues/367
  cryptonite = dontCheck super.cryptonite;
}
// lib.optionalAttrs (with pkgs.stdenv.hostPlatform; isAarch && isAndroid) {
  # android is not currently allowed as 'supported-platforms' by hackage2nix
  android-activity = unmarkBroken super.android-activity;
}
