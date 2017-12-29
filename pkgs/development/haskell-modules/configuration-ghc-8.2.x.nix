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

  # cabal-install can use the native Cabal library.
  cabal-install = super.cabal-install.override { Cabal = null; };

  # jailbreak-cabal doesn't seem to work right with the native Cabal version.
  jailbreak-cabal = pkgs.haskell.packages.ghc802.jailbreak-cabal;

  # https://github.com/bmillwood/applicative-quoters/issues/6
  applicative-quoters = appendPatch super.applicative-quoters (pkgs.fetchpatch {
    url = "https://patch-diff.githubusercontent.com/raw/bmillwood/applicative-quoters/pull/7.patch";
    sha256 = "026vv2k3ks73jngwifszv8l59clg88pcdr4mz0wr0gamivkfa1zy";
  });

  ## GHC > 8.0.2

  # http://hub.darcs.net/dolio/vector-algorithms/issue/9#comment-20170112T145715
  vector-algorithms = dontCheck super.vector-algorithms;

  # https://github.com/thoughtbot/yesod-auth-oauth2/pull/77
  yesod-auth-oauth2 = doJailbreak super.yesod-auth-oauth2;

  # https://github.com/nominolo/ghc-syb/issues/20
  ghc-syb-utils = dontCheck super.ghc-syb-utils;

  # Work around overly restrictive constraints on the version of 'base'.
  ChasingBottoms = doJailbreak super.ChasingBottoms;
  hashable = doJailbreak super.hashable;

}
