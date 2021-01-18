{ pkgs, haskellLib }:

with haskellLib;

self: super: {

  # This compiler version needs llvm 5.x.
  llvmPackages = pkgs.llvmPackages_5;

  # Disable GHC 8.4.x core libraries.
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
  hpc = null;
  integer-gmp = null;
  mtl = null;
  parsec = null;
  pretty = null;
  process = null;
  rts = null;
  stm = null;
  template-haskell = null;
  terminfo = null;
  text = null;
  time = null;
  transformers = null;
  unix = null;
  xhtml = null;

  # Needs Cabal 3.2.x.
  cabal-install = super.cabal-install.overrideScope (self: super: { Cabal = self.Cabal_3_2_1_0; });
  jailbreak-cabal = super.jailbreak-cabal.override { Cabal = self.Cabal_3_2_1_0; };

  # Restricts aeson to <1.4
  # https://github.com/purescript/purescript/pull/3537
  purescript = doJailbreak super.purescript;

  # https://github.com/jcristovao/enclosed-exceptions/issues/12
  enclosed-exceptions = dontCheck super.enclosed-exceptions;

  # https://github.com/jaor/xmobar/issues/356
  xmobar = super.xmobar.overrideScope (self: super: { hinotify = self.hinotify_0_3_9; });
  hinotify_0_3_9 = dontCheck (doJailbreak super.hinotify_0_3_9); # allow async 2.2.x

  # Reduction stack overflow; size = 38
  # https://github.com/jystic/hadoop-tools/issues/31
  hadoop-rpc =
    let patch = pkgs.fetchpatch
          { url = "https://github.com/shlevy/hadoop-tools/commit/f03a46cd15ce3796932c3382e48bcbb04a6ee102.patch";
            sha256 = "09ls54zy6gx84fmzwgvx18ssgm740cwq6ds70p0p125phi54agcp";
            stripLen = 1;
          };
    in appendPatch super.hadoop-rpc patch;

  # stack-1.9.1 needs Cabal 2.4.x, a recent version of hpack, and a non-recent
  # version of yaml. Go figure. We avoid overrideScope here because using it to
  # change Cabal would re-compile every single package instead of just those
  # that have it as an actual library dependency. The explicit overrides are
  # more verbose but friendlier for Hydra.
  stack = (doJailbreak super.stack).override {
    Cabal = self.Cabal_2_4_1_0;
    hpack = self.hpack.override { Cabal = self.Cabal_2_4_1_0; };
    hackage-security = self.hackage-security.override { Cabal = self.Cabal_2_4_1_0; };
  };

  # Older GHC versions need these additional dependencies.
  aeson = addBuildDepend super.aeson self.contravariant;
  base-compat-batteries = addBuildDepend super.base-compat-batteries self.contravariant;

  # Newer versions don't compile.
  resolv = self.resolv_0_1_1_2;

  # The old Haddock cannot process the newer documentation syntax.
  fast-logger = dontHaddock super.fast-logger;

  # ghc versions prior to 8.8.x needs additional dependency to compile successfully.
  ghc-lib-parser-ex = addBuildDepend super.ghc-lib-parser-ex self.ghc-lib-parser;

}
