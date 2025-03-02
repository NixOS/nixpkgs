{ pkgs, haskellLib }:

with haskellLib;

let
  inherit (pkgs.stdenv.hostPlatform) isDarwin;
  inherit (pkgs) lib;
in

self: super: {

  llvmPackages = pkgs.lib.dontRecurseIntoAttrs self.ghc.llvmPackages;

  # Disable GHC core libraries.
  array = null;
  base = null;
  binary = null;
  bytestring = null;
  Cabal = null;
  Cabal-syntax = null;
  containers = null;
  deepseq = null;
  directory = null;
  exceptions = null;
  filepath = null;
  ghc-bignum = null;
  ghc-boot = null;
  ghc-boot-th = null;
  ghc-compact = null;
  ghc-heap = null;
  ghc-prim = null;
  ghci = null;
  haskeline = null;
  hpc = null;
  integer-gmp = null;
  libiserv = null;
  mtl = null;
  parsec = null;
  pretty = null;
  process = null;
  rts = null;
  stm = null;
  semaphore-compat = null;
  system-cxx-std-lib = null;
  template-haskell = null;
  # GHC only builds terminfo if it is a native compiler
  terminfo = if pkgs.stdenv.hostPlatform == pkgs.stdenv.buildPlatform then null else doDistribute self.terminfo_0_4_1_7;
  text = null;
  time = null;
  transformers = null;
  unix = null;
  xhtml = null;

  #
  # Version upgrades
  #
  megaparsec = doDistribute self.megaparsec_9_7_0;
  ghc-tags = self.ghc-tags_1_8;

  #
  # Jailbreaks
  #
  hashing = doJailbreak super.hashing; # bytestring <0.12
  hevm = appendPatch (pkgs.fetchpatch {
    url = "https://github.com/hellwolf/hevm/commit/338674d1fe22d46ea1e8582b24c224d76d47d0f3.patch";
    name = "release-0.54.2-ghc-9.8.4-patch";
    sha256 = "sha256-Mo65FfP1nh7QTY+oLia22hj4eV2v9hpXlYsrFKljA3E=";
  }) super.hevm;
  primitive-unlifted = doJailbreak super.primitive-unlifted; # bytestring < 0.12
  hw-prim = doJailbreak super.hw-prim; # doctest < 0.22, ghc-prim < 0.11, hedgehog < 1.4
  HaskellNet-SSL = doJailbreak super.HaskellNet-SSL; # bytestring >=0.9 && <0.12
  saltine = doJailbreak super.saltine; # bytestring  && <0.12, deepseq <1.5, text > 1.2 && <1.3 || >=2.0 && <2.1
  inflections = doJailbreak super.inflections; # text >=0.2 && <2.1
  broadcast-chan = doJailbreak super.broadcast-chan; # base <4.19  https://github.com/merijn/broadcast-chan/pull/19

  #
  # Test suite issues
  #
  unordered-containers = dontCheck super.unordered-containers; # ChasingBottoms doesn't support base 4.20
  pcre-heavy = dontCheck super.pcre-heavy; # GHC warnings cause the tests to fail

  #
  # Other build fixes
  #

  # 2023-12-23: It needs this to build under ghc-9.6.3.
  #   A factor of 100 is insufficient, 200 seems seems to work.
  hip = appendConfigureFlag "--ghc-options=-fsimpl-tick-factor=200" super.hip;
}
// lib.optionalAttrs (lib.versionAtLeast super.ghc.version "9.8.3") {
  # Breakage related to GHC 9.8.3 / deepseq 1.5.1.0
  # https://github.com/typeable/generic-arbitrary/issues/18
  generic-arbitrary = dontCheck super.generic-arbitrary;
}
