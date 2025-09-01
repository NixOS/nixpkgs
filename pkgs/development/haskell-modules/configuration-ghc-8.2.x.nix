{ pkgs, haskellLib }:

with haskellLib;

self: super: {

  # Suitable LLVM version.
  llvmPackages = pkgs.llvmPackages;

  # Disable GHC 8.2.x core libraries.
  array = null;
  base = null;
  binary = null;
  bytestring = null;
  Cabal = null;
  containers = null;
  deepseq = null;
  directory = null;
  filepath = null;
  ghc-boot = null;
  ghc-boot-th = null;
  ghc-compact = null;
  ghc-heap = null;
  ghc-prim = null;
  ghci = null;
  haskeline = null;
  hoopl = null;
  hpc = null;
  integer-gmp = null;
  pretty = null;
  process = null;
  rts = null;
  template-haskell = null;
  terminfo = null;
  time = null;
  transformers = null;
  unix = null;
  xhtml = null;

  # These are now core libraries in GHC 8.4.x.
  # Setup: ./mtl.cabal:59: Parse of field 'build-depends' failed.
  mtl = overrideCabal (drv: {
    version = "2.2.2";
    sha256 = "1xmy5741h8cyy0d91ahvqdz2hykkk20l8br7lg1rccnkis5g80w8";
    editedCabalFile = null;
    revision = null;
  }) super.mtl_2_3_1;
  parsec = self.parsec_3_1_14_0;
  stm = self.stm_2_5_0_0;
  text = self.text_1_2_4_0;

  # Module ‘GHC.Exts’ does not export ‘word32ToInt32#’
  alex = overrideCabal (drv: {
    version = "3.5.1.0";
    sha256 = "01rax51p8p91a5jv5i56fny4lzmwgvjlxh767gh9x5gbz23gwbn9";
  }) super.alex;

  # Needs Cabal 3.0.x.
  jailbreak-cabal = super.jailbreak-cabal.override { Cabal = self.Cabal_3_2_1_0; };

  # https://github.com/bmillwood/applicative-quoters/issues/6
  applicative-quoters = appendPatch super.applicative-quoters (
    pkgs.fetchpatch {
      url = "https://patch-diff.githubusercontent.com/raw/bmillwood/applicative-quoters/pull/7.patch";
      sha256 = "026vv2k3ks73jngwifszv8l59clg88pcdr4mz0wr0gamivkfa1zy";
    }
  );

  # https://github.com/nominolo/ghc-syb/issues/20
  ghc-syb-utils = dontCheck super.ghc-syb-utils;

  # Upstream failed to distribute the testsuite for 8.2
  # https://github.com/alanz/ghc-exactprint/pull/60
  ghc-exactprint = dontCheck super.ghc-exactprint;

  # Reduction stack overflow; size = 38
  # https://github.com/jystic/hadoop-tools/issues/31
  hadoop-rpc =
    let
      patch = pkgs.fetchpatch {
        url = "https://github.com/shlevy/hadoop-tools/commit/f03a46cd15ce3796932c3382e48bcbb04a6ee102.patch";
        sha256 = "09ls54zy6gx84fmzwgvx18ssgm740cwq6ds70p0p125phi54agcp";
        stripLen = 1;
      };
    in
    appendPatch super.hadoop-rpc patch;

  # Custom Setup.hs breaks with Cabal 2
  # https://github.com/NICTA/coordinate/pull/4
  coordinate =
    let
      patch = pkgs.fetchpatch {
        url = "https://github.com/NICTA/coordinate/pull/4.patch";
        sha256 = "06sfxk5cyd8nqgjyb95jkihxxk8m6dw9m3mlv94sm2qwylj86gqy";
      };
    in
    appendPatch super.coordinate patch;

  # https://github.com/purescript/purescript/issues/3189
  purescript = doJailbreak (super.purescript);

  # These packages need Cabal 2.2.x, which is not the default.
  cabal2nix = super.cabal2nix.overrideScope (self: super: { Cabal = self.Cabal_2_2_0_1; });
  cabal2spec = super.cabal2spec.overrideScope (self: super: { Cabal = self.Cabal_2_2_0_1; });
  distribution-nixpkgs = super.distribution-nixpkgs.overrideScope (
    self: super: { Cabal = self.Cabal_2_2_0_1; }
  );
  stack = super.stack.overrideScope (self: super: { Cabal = self.Cabal_2_2_0_1; });

  # happy-lib: Setup: Encountered missing dependencies: transformers >=0.5.6.2
  happy = overrideCabal (drv: {
    version = "1.20.1.1";
    sha256 = "06w8g3lfk2ynrfhqznhp1mnp8a5b64lj6qviixpndzf5lv2psklb";
  }) super.happy;
  happy-lib = null;

  # Older GHC versions need these additional dependencies.
  ListLike = addBuildDepend super.ListLike self.semigroups;
  base-compat-batteries = addBuildDepend super.base-compat-batteries self.contravariant;

  # ghc versions prior to 8.8.x needs additional dependency to compile successfully.
  ghc-lib-parser-ex = addBuildDepend super.ghc-lib-parser-ex self.ghc-lib-parser;

}
