{ pkgs, haskellLib }:

with haskellLib;

self: super: {

  # Suitable LLVM version.
  llvmPackages = pkgs.llvmPackages_39;

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
  mtl = self.mtl_2_2_2;
  parsec = self.parsec_3_1_13_0;
  stm = self.stm_2_4_5_0;
  text = self.text_1_2_3_0;

  # Make sure we can still build Cabal 1.x.
  Cabal_1_24_2_0 = overrideCabal super.Cabal_1_24_2_0 (drv: {
    prePatch = "sed -i -e 's/process.*< 1.5,/process,/g' Cabal.cabal";
  });

  # Build with the latest Cabal version, which works best albeit not perfectly.
  jailbreak-cabal = super.jailbreak-cabal.override { Cabal = self.Cabal_2_2_0_1; };

  # https://github.com/bmillwood/applicative-quoters/issues/6
  applicative-quoters = appendPatch super.applicative-quoters (pkgs.fetchpatch {
    url = "https://patch-diff.githubusercontent.com/raw/bmillwood/applicative-quoters/pull/7.patch";
    sha256 = "026vv2k3ks73jngwifszv8l59clg88pcdr4mz0wr0gamivkfa1zy";
  });

  # https://github.com/nominolo/ghc-syb/issues/20
  ghc-syb-utils = dontCheck super.ghc-syb-utils;

  # Upstream failed to distribute the testsuite for 8.2
  # https://github.com/alanz/ghc-exactprint/pull/60
  ghc-exactprint = dontCheck super.ghc-exactprint;

  # Reduction stack overflow; size = 38
  # https://github.com/jystic/hadoop-tools/issues/31
  hadoop-rpc =
    let patch = pkgs.fetchpatch
          { url = https://github.com/shlevy/hadoop-tools/commit/f03a46cd15ce3796932c3382e48bcbb04a6ee102.patch;
            sha256 = "09ls54zy6gx84fmzwgvx18ssgm740cwq6ds70p0p125phi54agcp";
            stripLen = 1;
          };
    in appendPatch super.hadoop-rpc patch;

  # Custom Setup.hs breaks with Cabal 2
  # https://github.com/NICTA/coordinate/pull/4
  coordinate =
    let patch = pkgs.fetchpatch
          { url = https://github.com/NICTA/coordinate/pull/4.patch;
            sha256 = "06sfxk5cyd8nqgjyb95jkihxxk8m6dw9m3mlv94sm2qwylj86gqy";
          };
    in appendPatch super.coordinate patch;

  # https://github.com/purescript/purescript/issues/3189
  purescript = doJailbreak (super.purescript);

  # These packages need Cabal 2.2.x, which is not the default.
  cabal2nix = super.cabal2nix.overrideScope (self: super: { Cabal = self.Cabal_2_2_0_1; });
  cabal2spec = super.cabal2spec.overrideScope (self: super: { Cabal = self.Cabal_2_2_0_1; });
  distribution-nixpkgs = super.distribution-nixpkgs.overrideScope (self: super: { Cabal = self.Cabal_2_2_0_1; });
  hackage-db_2_0_1 = super.hackage-db_2_0_1.overrideScope (self: super: { Cabal = self.Cabal_2_2_0_1; });
  stack = super.stack.overrideScope (self: super: { Cabal = self.Cabal_2_2_0_1; });
  stylish-cabal = dontCheck (super.stylish-cabal.overrideScope (self: super: {
    Cabal = self.Cabal_2_2_0_1;
    haddock-library = dontHaddock (dontCheck self.haddock-library_1_5_0_1);
  }));

}
