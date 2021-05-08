# ARM-SPECIFIC OVERRIDES FOR THE HASKELL PACKAGE SET IN NIXPKGS
#
# This extension is applied to all haskell package sets in nixpkgs
# if `stdenv.hostPlatform.isAarch32 || stdenv.hostPlatform.isAarch64`
# to apply arm specific workarounds or fixes.
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

self: super: {
  # COMMON ARM OVERRIDES

  # moved here from configuration-common.nix, no reason given.
  servant-docs = dontCheck super.servant-docs;
  swagger2 = dontHaddock (dontCheck super.swagger2);

  # Similar to https://ghc.haskell.org/trac/ghc/ticket/13062
  happy = dontCheck super.happy;

} // lib.optionalAttrs pkgs.stdenv.hostPlatform.isAarch64 {
  # AARCH64-SPECIFIC OVERRIDES

  # Doctests fail on aarch64 due to a GHCi linking bug
  # https://gitlab.haskell.org/ghc/ghc/-/issues/15275#note_295437
  # TODO: figure out if needed on aarch32 as well
  language-nix = dontCheck super.language-nix;
  trifecta = dontCheck super.trifecta;
  ad = dontCheck super.ad;
  vinyl = dontCheck super.vinyl;
  BNFC = dontCheck super.BNFC;
  C-structs = dontCheck super.C-structs;
  accelerate = dontCheck super.accelerate;
  focuslist = dontCheck super.focuslist;
  flight-kml = dontCheck super.flight-kml;
  exact-real = dontCheck super.exact-real;
  autoapply = dontCheck super.autoapply;
  hint = dontCheck super.hint;
  hgeometry = dontCheck super.hgeometry;
  headroom = dontCheck super.headroom;
  haskell-time-range = dontCheck super.haskell-time-range;
  hsakamai = dontCheck super.hsakamai;
  hsemail-ns = dontCheck super.hsemail-ns;
  openapi3 = dontCheck super.openapi3;
  strict-writer = dontCheck super.strict-writer;

  # https://github.com/ekmett/half/issues/35
  half = dontCheck super.half;

} // lib.optionalAttrs pkgs.stdenv.hostPlatform.isAarch32 {
  # AARCH32-SPECIFIC OVERRIDES

}
