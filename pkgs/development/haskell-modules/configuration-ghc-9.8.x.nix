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

  # HLS
  # https://haskell-language-server.readthedocs.io/en/latest/support/plugin-support.html
  haskell-language-server = super.haskell-language-server.override {
    hls-class-plugin = null;
    hls-floskell-plugin = null;
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

  # Version upgrades
  alex = doDistribute self.alex_3_4_0_1;
  some = doDistribute self.some_1_0_6;
  tagged = doDistribute self.tagged_0_8_8;
  th-abstraction = doDistribute self.th-abstraction_0_6_0_0;
  hspec-core = doDistribute self.hspec-core_2_11_7;
  hspec-meta = doDistribute self.hspec-meta_2_11_7;
  hspec-discover = doDistribute self.hspec-discover_2_11_7;
  hspec = doDistribute self.hspec_2_11_7;
  hspec-expectations = doDistribute self.hspec-expectations_0_8_4;
  bifunctors = doDistribute self.bifunctors_5_6_1;
  free = doDistribute self.free_5_2;
  semigroupoids = doDistribute self.semigroupoids_6_0_0_1;
  doctest = doDistribute self.doctest_0_22_2;
  ghc-lib-parser = doDistribute self.ghc-lib-parser_9_8_1_20231121;
  ghc-lib-parser-ex = doDistribute self.ghc-lib-parser-ex_9_8_0_0;
  ghc-lib = doDistribute self.ghc-lib_9_8_1_20231121;
  megaparsec = doDistribute self.megaparsec_9_6_1;
  tasty-hspec = doDistribute self.tasty-hspec_1_2_0_4;
  hedgehog = doDistribute self.hedgehog_1_4;
  rebase = doDistribute self.rebase_1_20_2;
  rerebase = doDistribute self.rerebase_1_20_2;
  aeson = doDistribute self.aeson_2_2_1_0;
  aeson-pretty = doDistribute self.aeson-pretty_0_8_10;
  attoparsec-aeson = doDistribute self.attoparsec-aeson_2_2_0_1;
  ormolu = doDistribute self.ormolu_0_7_3_0;
  fourmolu = doDistribute (dontCheck self.fourmolu_0_14_1_0);

  # Jailbreaks
  commutative-semigroups = doJailbreak super.commutative-semigroups; # base < 4.19
  ghc-trace-events = doJailbreak super.ghc-trace-events; # text < 2.1, bytestring < 0.12, base < 4.19
  primitive-unlifted = doJailbreak super.primitive-unlifted; # bytestring < 0.12
  newtype-generics = doJailbreak super.newtype-generics; # base < 4.19
  hw-prim = doJailbreak super.hw-prim; # doctest < 0.22, ghc-prim < 0.11, hedgehog < 1.4
  hw-fingertree = doJailbreak super.hw-fingertree; # deepseq <1.5, doctest < 0.22, hedgehog < 1.4
  # Too strict bound on base, believe it or not.
  # https://github.com/judah/terminfo/pull/55#issuecomment-1876894232
  terminfo_0_4_1_6 = doJailbreak super.terminfo_0_4_1_6;

  # Test suite issues
  unordered-containers = dontCheck super.unordered-containers; # ChasingBottoms doesn't support base 4.20
  lifted-base = dontCheck super.lifted-base; # doesn't compile with transformers == 0.6.*
  # https://github.com/wz1000/HieDb/issues/64
  hiedb = overrideCabal (drv: {
    testFlags = drv.testFlags or [ ] ++ [
      "--match" "!/hiedb/Command line/point-info/correctly prints type signatures/"
    ];
  }) super.hiedb;

  # Unbroken due to hspec* upgrades
  hspec-api = doDistribute (unmarkBroken super.hspec-api);
}
