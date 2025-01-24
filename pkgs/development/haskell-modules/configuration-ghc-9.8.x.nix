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
  terminfo = if pkgs.stdenv.hostPlatform == pkgs.stdenv.buildPlatform then null else doDistribute self.terminfo_0_4_1_6;
  text = null;
  time = null;
  transformers = null;
  unix = null;
  xhtml = null;

  #
  # Version upgrades
  #
  megaparsec = doDistribute self.megaparsec_9_7_0;
  ghc-syntax-highlighter = self.ghc-syntax-highlighter_0_0_12_0;
  ghc-tags = self.ghc-tags_1_8;

  #
  # Jailbreaks
  #
  blaze-svg = doJailbreak super.blaze-svg; # base <4.19
  commutative-semigroups = doJailbreak super.commutative-semigroups; # base < 4.19
  diagrams-lib = doJailbreak super.diagrams-lib; # base <4.19, text <2.1
  diagrams-postscript = doJailbreak super.diagrams-postscript;  # base <4.19, bytestring <0.12
  diagrams-svg = doJailbreak super.diagrams-svg;  # base <4.19, text <2.1
  ghc-trace-events = doJailbreak super.ghc-trace-events; # text < 2.1, bytestring < 0.12, base < 4.19
  hashing = doJailbreak super.hashing; # bytestring <0.12
  hevm = appendPatch (pkgs.fetchpatch {
    url = "https://github.com/hellwolf/hevm/commit/338674d1fe22d46ea1e8582b24c224d76d47d0f3.patch";
    name = "release-0.54.2-ghc-9.8.4-patch";
    sha256 = "sha256-Mo65FfP1nh7QTY+oLia22hj4eV2v9hpXlYsrFKljA3E=";
  }) super.hevm;
  json-sop = doJailbreak super.json-sop; # aeson <2.2, base <4.19, text <2.1
  primitive-unlifted = doJailbreak super.primitive-unlifted; # bytestring < 0.12
  statestack = doJailbreak super.statestack; # base < 4.19
  newtype-generics = doJailbreak super.newtype-generics; # base < 4.19
  hw-prim = doJailbreak super.hw-prim; # doctest < 0.22, ghc-prim < 0.11, hedgehog < 1.4
  svg-builder = doJailbreak super.svg-builder; # base <4.19, bytestring <0.12, text <2.1
  # Too strict bound on base, believe it or not.
  # https://github.com/judah/terminfo/pull/55#issuecomment-1876894232
  terminfo_0_4_1_6 = doJailbreak super.terminfo_0_4_1_6;
  HaskellNet-SSL = doJailbreak super.HaskellNet-SSL; # bytestring >=0.9 && <0.12
  raven-haskell = doJailbreak super.raven-haskell; # aeson <2.2
  saltine = doJailbreak super.saltine; # bytestring  && <0.12, deepseq <1.5, text > 1.2 && <1.3 || >=2.0 && <2.1
  stripe-concepts = doJailbreak super.stripe-concepts; # text >=1.2.5 && <1.3 || >=2.0 && <2.1
  stripe-signature = doJailbreak super.stripe-signature; # text >=1.2.5 && <1.3 || >=2.0 && <2.1
  string-random = doJailbreak super.string-random; # text >=1.2.2.1 && <2.1
  inflections = doJailbreak super.inflections; # text >=0.2 && <2.1
  universe-some = doJailbreak super.universe-some; # th-abstraction < 0.7
  broadcast-chan = doJailbreak super.broadcast-chan; # base <4.19  https://github.com/merijn/broadcast-chan/pull/19

  #
  # Test suite issues
  #
  unordered-containers = dontCheck super.unordered-containers; # ChasingBottoms doesn't support base 4.20
  lifted-base = dontCheck super.lifted-base; # doesn't compile with transformers == 0.6.*
  bsb-http-chunked = dontCheck super.bsb-http-chunked; # umaintained, test suite doesn't compile anymore
  pcre-heavy = dontCheck super.pcre-heavy; # GHC warnings cause the tests to fail

  #
  # Other build fixes
  #

  # 2023-12-23: It needs this to build under ghc-9.6.3.
  #   A factor of 100 is insufficent, 200 seems seems to work.
  hip = appendConfigureFlag "--ghc-options=-fsimpl-tick-factor=200" super.hip;
}
// lib.optionalAttrs (lib.versionAtLeast super.ghc.version "9.8.3") {
  # Breakage related to GHC 9.8.3 / deepseq 1.5.1.0
  # https://github.com/typeable/generic-arbitrary/issues/18
  generic-arbitrary = dontCheck super.generic-arbitrary;
}
