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

  # Make sure we can still build Cabal 1.x.
  Cabal_1_24_2_0 = overrideCabal super.Cabal_1_24_2_0 (drv: {
    prePatch = "sed -i -e 's/process.*< 1.5,/process,/g' Cabal.cabal";
  });

  # cabal-install can use the native Cabal library.
  cabal-install = super.cabal-install.override { Cabal = null; };

  # jailbreak-cabal doesn't seem to work right with the native Cabal version.
  jailbreak-cabal = pkgs.haskell.packages.ghc802.jailbreak-cabal;

  # https://github.com/bmillwood/applicative-quoters/issues/6
  applicative-quoters = appendPatch super.applicative-quoters (pkgs.fetchpatch {
    url = "https://patch-diff.githubusercontent.com/raw/bmillwood/applicative-quoters/pull/7.patch";
    sha256 = "026vv2k3ks73jngwifszv8l59clg88pcdr4mz0wr0gamivkfa1zy";
  });

  # http://hub.darcs.net/dolio/vector-algorithms/issue/9#comment-20170112T145715
  vector-algorithms = dontCheck super.vector-algorithms;

  # https://github.com/thoughtbot/yesod-auth-oauth2/pull/77
  yesod-auth-oauth2 = doJailbreak super.yesod-auth-oauth2;

  # https://github.com/nominolo/ghc-syb/issues/20
  ghc-syb-utils = dontCheck super.ghc-syb-utils;

  # Work around overly restrictive constraints on the version of 'base'.
  ChasingBottoms = doJailbreak super.ChasingBottoms;
  hashable = doJailbreak super.hashable;
  protolude = doJailbreak super.protolude;
  quickcheck-instances = doJailbreak super.quickcheck-instances;

  # https://github.com/aristidb/aws/issues/238
  aws = doJailbreak super.aws;

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
}
