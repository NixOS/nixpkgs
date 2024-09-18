{ pkgs, haskellLib }:

with haskellLib;

let
  inherit (pkgs.stdenv.hostPlatform) isDarwin;

  disableParallelBuilding = haskellLib.overrideCabal (drv: { enableParallelBuilding = false; });
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
  # Version upgrades
  #
  th-abstraction = doDistribute self.th-abstraction_0_7_0_0;
  ghc-lib-parser = doDistribute self.ghc-lib-parser_9_8_2_20240223;
  ghc-lib-parser-ex = doDistribute self.ghc-lib-parser-ex_9_8_0_2;
  ghc-lib = doDistribute self.ghc-lib_9_8_2_20240223;
  megaparsec = doDistribute self.megaparsec_9_6_1;
  # aeson 2.2.3.0 seemingly unnecessesarily bumped the lower bound on hashable
  # https://github.com/haskell/aeson/commit/1a666febd0775d8e88d315ece1b97cd20602fb5f
  aeson = doJailbreak (doDistribute self.aeson_2_2_3_0);
  attoparsec-aeson = doDistribute self.attoparsec-aeson_2_2_2_0;
  xmonad = doDistribute self.xmonad_0_18_0;
  apply-refact = self.apply-refact_0_14_0_0;
  ormolu = self.ormolu_0_7_4_0;
  fourmolu = self.fourmolu_0_15_0_0;
  stylish-haskell = self.stylish-haskell_0_14_6_0;
  hlint = self.hlint_3_8;
  ghc-syntax-highlighter = self.ghc-syntax-highlighter_0_0_12_0;
  websockets = self.websockets_0_13_0_0;
  th-desugar = doJailbreak self.th-desugar_1_16; # th-abstraction >=0.6 && <0.7
  singletons-th = self.singletons-th_3_3;
  singletons-base = self.singletons-base_3_3;
  ghc-tags = self.ghc-tags_1_8;

  # A given major version of ghc-exactprint only supports one version of GHC.
  ghc-exactprint = self.ghc-exactprint_1_8_0_0;
  ghc-exactprint_1_8_0_0 = addBuildDepends [
    self.Diff
    self.HUnit
    self.data-default
    self.extra
    self.free
    self.ghc-paths
    self.ordered-containers
    self.silently
    self.syb
  ] super.ghc-exactprint_1_8_0_0;

  #
  # Jailbreaks
  #
  blaze-svg = doJailbreak super.blaze-svg; # base <4.19
  commutative-semigroups = doJailbreak super.commutative-semigroups; # base < 4.19
  dependent-sum-template = doJailbreak super.dependent-sum-template_0_2_0_1; # template-haskell < 2.21
  diagrams-lib = doJailbreak super.diagrams-lib; # base <4.19, text <2.1
  diagrams-postscript = doJailbreak super.diagrams-postscript;  # base <4.19, bytestring <0.12
  diagrams-svg = doJailbreak super.diagrams-svg;  # base <4.19, text <2.1
  generics-sop = doJailbreak super.generics-sop_0_5_1_4; # th-abstraction >=0.6 && <0.7
  ghc-trace-events = doJailbreak super.ghc-trace-events; # text < 2.1, bytestring < 0.12, base < 4.19
  hashing = doJailbreak super.hashing; # bytestring <0.12
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

  # Loosen bounds
  patch = appendPatch (pkgs.fetchpatch {
    url = "https://github.com/reflex-frp/patch/commit/91fed138483a7bf2b098d45b9e5cc36191776320.patch";
    sha256 = "sha256-/KLfIshia88lU5G/hA7ild7+a2mqc7qgSa9AEBqEqkQ=";
  }) super.patch;
  reflex = appendPatch (pkgs.fetchpatch {
    url = "https://github.com/reflex-frp/reflex/commit/0ac53ca3eab2649dd3f3edc585e10af8d13b28cd.patch";
    sha256 = "sha256-umjwgdSKebJdRrXjwHhsi8HBqotx1vFibY9ttLkyT/0=";
  }) super.reflex;

  # https://gitlab.haskell.org/ghc/ghc/-/issues/23392
  gi-gtk = disableParallelBuilding super.gi-gtk;

}
