{ pkgs, haskellLib }:

with haskellLib;

let
  inherit (pkgs.stdenv.hostPlatform) isDarwin;
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
  # HLS
  # https://haskell-language-server.readthedocs.io/en/latest/support/plugin-support.html
  #
  haskell-language-server = super.haskell-language-server.override {
    hls-class-plugin = null;
    hls-fourmolu-plugin = null;
    hls-gadt-plugin = null;
    hls-hlint-plugin = null;
    hls-ormolu-plugin = null;
    hls-refactor-plugin = null;
    hls-rename-plugin = null;
    hls-retrie-plugin = null;
    hls-splice-plugin = null;
    hls-stylish-haskell-plugin = null;
  };

  #
  # Version upgrades
  #
  th-abstraction = doDistribute self.th-abstraction_0_6_0_0;
  ghc-lib-parser = doDistribute self.ghc-lib-parser_9_8_1_20231121;
  ghc-lib-parser-ex = doDistribute self.ghc-lib-parser-ex_9_8_0_0;
  ghc-lib = doDistribute self.ghc-lib_9_8_1_20231121;
  megaparsec = doDistribute self.megaparsec_9_6_1;
  aeson = doDistribute self.aeson_2_2_1_0;
  attoparsec-aeson = doDistribute self.attoparsec-aeson_2_2_0_1;
  ormolu = doDistribute self.ormolu_0_7_3_0;
  fourmolu = doDistribute (dontCheck self.fourmolu_0_14_1_0);
  xmonad = doDistribute self.xmonad_0_18_0;
  hlint = doDistribute self.hlint_3_8;

  #
  # Jailbreaks
  #
  blaze-svg = doJailbreak super.blaze-svg; # base <4.19
  commutative-semigroups = doJailbreak super.commutative-semigroups; # base < 4.19
  diagrams-lib = doJailbreak super.diagrams-lib; # base <4.19, text <2.1
  diagrams-postscript = doJailbreak super.diagrams-postscript;  # base <4.19, bytestring <0.12
  diagrams-svg = doJailbreak super.diagrams-svg;  # base <4.19, text <2.1
  ghc-trace-events = doJailbreak super.ghc-trace-events; # text < 2.1, bytestring < 0.12, base < 4.19
  primitive-unlifted = doJailbreak super.primitive-unlifted; # bytestring < 0.12
  statestack = doJailbreak super.statestack; # base < 4.19
  newtype-generics = doJailbreak super.newtype-generics; # base < 4.19
  hw-prim = doJailbreak super.hw-prim; # doctest < 0.22, ghc-prim < 0.11, hedgehog < 1.4
  svg-builder = doJailbreak super.svg-builder; # base <4.19, bytestring <0.12, text <2.1
  # Too strict bound on base, believe it or not.
  # https://github.com/judah/terminfo/pull/55#issuecomment-1876894232
  terminfo_0_4_1_6 = doJailbreak super.terminfo_0_4_1_6;

  #
  # Test suite issues
  #
  unordered-containers = dontCheck super.unordered-containers; # ChasingBottoms doesn't support base 4.20
  lifted-base = dontCheck super.lifted-base; # doesn't compile with transformers == 0.6.*
  hourglass = dontCheck super.hourglass; # umaintained, test suite doesn't compile anymore
  bsb-http-chunked = dontCheck super.bsb-http-chunked; # umaintained, test suite doesn't compile anymore

  #
  # Other build fixes
  #

  # 2023-12-23: It needs this to build under ghc-9.6.3.
  #   A factor of 100 is insufficent, 200 seems seems to work.
  hip = appendConfigureFlag "--ghc-options=-fsimpl-tick-factor=200" super.hip;

  # Fix build with text-2.x.
  libmpd = appendPatch (pkgs.fetchpatch
      { url = "https://github.com/vimus/libmpd-haskell/pull/138.patch";
        sha256 = "Q4fA2J/Tq+WernBo+UIMdj604ILOMlIYkG4Pr046DfM=";
      })
    super.libmpd;

  # Symbol syntax seems to have changed in 9.8, removing a seemingly redundant colon; appears to be an overspecified assertion.
  # https://github.com/wz1000/HieDb/issues/74
  hiedb =
    assert super.hiedb.version == "0.5.0.1";
    dontCheck super.hiedb;

}
