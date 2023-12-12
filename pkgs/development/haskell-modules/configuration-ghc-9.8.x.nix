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
  terminfo = if pkgs.stdenv.hostPlatform == pkgs.stdenv.buildPlatform then null else self.terminfo_0_4_1_6;
  text = null;
  time = null;
  transformers = null;
  unix = null;
  xhtml = null;

  aeson = super.aeson_2_2_1_0;
  aeson-pretty = super.aeson-pretty_0_8_10;
  attoparsec-aeson = super.attoparsec-aeson_2_2_0_1;
  alex = super.alex_3_4_0_1;
  bifunctors = super.bifunctors_5_6_1;
  cabal-install-solver = super.cabal-install-solver_3_10_2_1;
  doctest = super.doctest_0_22_2;
  free = super.free_5_2;
  # ghc-lib 9.8.1.20231121 required for Cabal to build: https://github.com/digital-asset/ghc-lib/issues/495
  ghc-lib = super.ghc-lib_9_8_1_20231121;
  ghc-lib-parser = super.ghc-lib-parser_9_8_1_20231121;
  ghc-lib-parser-ex = super.ghc-lib-parser-ex_9_8_0_0;
  github = super.github_0_29;
  hedgehog = super.hedgehog_1_4;
  hspec = super.hspec_2_11_7;
  hspec-core = super.hspec-core_2_11_7;
  hspec-discover = super.hspec-discover_2_11_7;
  hspec-hedgehog = super.hspec-hedgehog_0_1_1_0;
  hspec-meta = super.hspec-meta_2_11_7;
  megaparsec = super.megaparsec_9_6_1;
  megaparsec-tests = super.megaparsec-tests_9_6_1;
  ormolu = super.ormolu_0_7_3_0;
  rebase = super.rebase_1_20_1_1;
  rerebase = super.rerebase_1_20_1_1;
  semigroupoids = super.semigroupoids_6_0_0_1;
  singleton-bool = super.singleton-bool_0_1_7;
  some = super.some_1_0_6;
  tagged = super.tagged_0_8_8;
  tasty-hspec = super.tasty-hspec_1_2_0_4;
  th-abstraction = super.th-abstraction_0_6_0_0;

  cabal-fmt =
    if pkgs.stdenv.targetPlatform.isDarwin && pkgs.stdenv.targetPlatform.isAarch64 then
      overrideCabal (drv: {
        enableSeparateBinOutput = false;
      }) (super.cabal-fmt)
    else
      super.cabal-fmt;

  ChasingBottoms = dontCheck (doJailbreak super.ChasingBottoms); # base >=4.2 && <4.19

  # https://github.com/obsidiansystems/commutative-semigroups/issues/13
  commutative-semigroups = doJailbreak super.commutative-semigroups; # base >=4.6 && <4.19

  dates = doJailbreak super.dates; # base >=4.9 && <4.16

  double-conversion = overrideCabal (drv: {
    src = pkgs.fetchFromGitHub {
      owner = "haskell";
      repo = "double-conversion";
      rev = "d480fb057c5387251b8cfdeb3666b24087811219";
      sha256 = "1f2q5p9nh4ccyrkc2fx6xjiq8v15i6myf01ajcw541dqc8z5aiw0";
    };
    editedCabalFile = null;
    license = pkgs.lib.licenses.bsd2;
  }) super.double-conversion;

  # Tests fail due to the newly-built fourmolu not being in PATH
  # https://github.com/fourmolu/fourmolu/issues/231
  fourmolu = dontCheck super.fourmolu_0_14_1_0;

  generic-lens-core = doJailbreak super.generic-lens-core; # text >= 1.2 && < 1.3 || >= 2.0 && < 2.1

  # https://github.com/maoe/ghc-trace-events/issues/12
  ghc-trace-events = doJailbreak super.ghc-trace-events;

  # https://haskell-language-server.readthedocs.io/en/latest/support/plugin-support.html
  # lmao
  haskell-language-server = overrideCabal (drv: {
    configureFlags = ([
      "-f-class"
      "-f-rename"
      "-f-retrie"
      "-f-splice"
      "-f-gadt"
      "-f-floskell"
      "-f-fourmolu"
      "-f-ormolu"
      "-f-stylishhaskell"
      "-f-refactor"
    ]) ++ (drv.configureFlags or []);
  }) (super.haskell-language-server.override {
      hls-refactor-plugin = null;
      hls-class-plugin = null;
      hls-fourmolu-plugin = null;
      hls-gadt-plugin = null;
      hls-hlint-plugin = null;
      hls-ormolu-plugin = null;
      hls-rename-plugin = null;
      hls-stylish-haskell-plugin = null;
      hls-floskell-plugin = null;
      hls-retrie-plugin = null;
      hls-splice-plugin = null;
    });

  hiedb = dontCheck super.hiedb;

  hpc-coveralls = doJailbreak super.hpc-coveralls; # https://github.com/guillaume-nargeot/hpc-coveralls/issues/82

  # Because we're using hspec-core-2.11.7 :)
  hspec-api = unmarkBroken super.hspec-api;

  hw-fingertree = doJailbreak super.hw-fingertree; # deepseq >=1.4 && <1.5
  hw-fingertree-strict = doJailbreak super.hw-fingertree-strict; # deepseq >=1.4 && <1.5
  hw-prim = doJailbreak super.hw-prim; # ghc-prim >=0.5 && <0.11

  # Can't compile test suite: https://github.com/basvandijk/lifted-base/issues/36
  lifted-base = dontCheck super.lifted-base;

  newtype-generics = doJailbreak super.newtype-generics; # base >=4.9 && <4.19

  # https://github.com/haskell-primitive/primitive-unlifted/issues/39
  primitive-unlifted = doJailbreak super.primitive-unlifted_2_1_0_0; # bytestring >=0.10.8.2 && <0.12

  wl-pprint-extras = doJailbreak super.wl-pprint-extras; # containers >=0.4 && <0.6 is too tight; https://github.com/ekmett/wl-pprint-extras/issues/17
}
