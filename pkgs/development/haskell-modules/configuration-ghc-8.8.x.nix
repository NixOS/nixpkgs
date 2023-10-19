{ pkgs, haskellLib }:

with haskellLib;

let
  inherit (pkgs.stdenv.hostPlatform) isDarwin;
in

self: super: {

  llvmPackages = pkgs.lib.dontRecurseIntoAttrs self.ghc.llvmPackages;

  # Disable GHC 8.8.x core libraries.
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
  libiserv = null;
  mtl = null;
  parsec = null;
  pretty = null;
  process = null;
  rts = null;
  stm = null;
  template-haskell = null;
  # GHC only builds terminfo if it is a native compiler
  terminfo = if pkgs.stdenv.hostPlatform == pkgs.stdenv.buildPlatform then null else self.terminfo_0_4_1_6;
  text = null;
  time = null;
  transformers = null;
  unix = null;
  # GHC only bundles the xhtml library if haddock is enabled, check if this is
  # still the case when updating: https://gitlab.haskell.org/ghc/ghc/-/blob/0198841877f6f04269d6050892b98b5c3807ce4c/ghc.mk#L463
  xhtml = if self.ghc.hasHaddock or true then null else self.xhtml_3000_3_0_0;
  # These core package only exist for GHC >= 9.4. The best we can do is feign
  # their existence to callPackages, but their is no shim for lower GHC versions.
  system-cxx-std-lib = null;

  # Need the Cabal-syntax-3.6.0.0 fake package for Cabal < 3.8 to allow callPackage and the constraint solver to work
  Cabal-syntax = self.Cabal-syntax_3_6_0_0;

  # GHC 8.8.x can build haddock version 2.23.*
  haddock = self.haddock_2_23_1;
  haddock-api = self.haddock-api_2_23_1;

  # This build needs a newer version of Cabal.
  cabal2spec = super.cabal2spec.override { Cabal = self.Cabal_3_2_1_0; };

  # Additionally depends on OneTuple for GHC < 9.0
  base-compat-batteries = addBuildDepend self.OneTuple super.base-compat-batteries;

  # For GHC < 9.4, some packages need data-array-byte as an extra dependency
  primitive = addBuildDepends [ self.data-array-byte ] super.primitive;
  hashable = addBuildDepends [
    self.data-array-byte
    self.base-orphans
  ] super.hashable;

  # Ignore overly restrictive upper version bounds.
  aeson-diff = doJailbreak super.aeson-diff;
  async = doJailbreak super.async;
  ChasingBottoms = doJailbreak super.ChasingBottoms;
  chell = doJailbreak super.chell;
  Diff = dontCheck super.Diff;
  doctest = doJailbreak super.doctest;
  hashable-time = doJailbreak super.hashable-time;
  hledger-lib = doJailbreak super.hledger-lib;  # base >=4.8 && <4.13, easytest >=0.2.1 && <0.3
  integer-logarithms = doJailbreak super.integer-logarithms;
  lucid = doJailbreak super.lucid;
  parallel = doJailbreak super.parallel;
  setlocale = doJailbreak super.setlocale;
  split = doJailbreak super.split;
  system-fileio = doJailbreak super.system-fileio;
  tasty-expected-failure = doJailbreak super.tasty-expected-failure;
  tasty-hedgehog = doJailbreak super.tasty-hedgehog;
  test-framework = doJailbreak super.test-framework;
  th-expand-syns = doJailbreak super.th-expand-syns;
  # TODO: remove when upstream accepts https://github.com/snapframework/io-streams-haproxy/pull/17
  io-streams-haproxy = doJailbreak super.io-streams-haproxy; # base >=4.5 && <4.13
  snap-server = doJailbreak super.snap-server;
  exact-pi = doJailbreak super.exact-pi;
  time-compat = doJailbreak super.time-compat;
  http-media = unmarkBroken (doJailbreak super.http-media);
  servant-server = unmarkBroken (doJailbreak super.servant-server);
  basement = doDistribute self.basement_0_0_14;
  foundation = doDistribute (dontCheck self.foundation_0_0_28);
  vault = dontHaddock super.vault;

  # https://github.com/snapframework/snap-core/issues/288
  snap-core = overrideCabal (drv: { prePatch = "substituteInPlace src/Snap/Internal/Core.hs --replace 'fail   = Fail.fail' ''"; }) super.snap-core;

  # Upstream ships a broken Setup.hs file.
  csv = overrideCabal (drv: { prePatch = "rm Setup.hs"; }) super.csv;

  # https://github.com/kowainik/relude/issues/241
  relude = dontCheck super.relude;

  # The current version 2.14.2 does not compile with ghc-8.8.x or newer because
  # of issues with Cabal 3.x.
  darcs = dontDistribute super.darcs;

  # liquidhaskell does not support ghc version 8.8.x.
  liquid = markBroken super.liquid;
  liquid-base = markBroken super.liquid-base;
  liquid-bytestring = markBroken super.liquid-bytestring;
  liquid-containers = markBroken super.liquid-containers;
  liquid-ghc-prim = markBroken super.liquid-ghc-prim;
  liquid-parallel = markBroken super.liquid-parallel;
  liquid-platform = markBroken super.liquid-platform;
  liquid-prelude = markBroken super.liquid-prelude;
  liquid-vector = markBroken super.liquid-vector;
  liquidhaskell = markBroken super.liquidhaskell;

  # This became a core library in ghc 8.10., so we don’t have an "exception" attribute anymore.
  exceptions = super.exceptions_0_10_7;

  ormolu = super.ormolu_0_2_0_0;

  ghc-api-compat = doDistribute (unmarkBroken super.ghc-api-compat_8_6);

  mime-string = disableOptimization super.mime-string;

  haskell-language-server =  throw "haskell-language-server dropped support for ghc 8.8 in version 1.9.0.0 please use a newer ghc version or an older nixpkgs version";

  hlint = self.hlint_3_2_8;

  ghc-lib-parser = doDistribute self.ghc-lib-parser_8_10_7_20220219;
  ghc-lib = doDistribute self.ghc-lib_8_10_7_20220219;

  # ghc versions which don’t match the ghc-lib-parser-ex version need the
  # additional dependency to compile successfully.
  ghc-lib-parser-ex = doDistribute (addBuildDepend self.ghc-lib-parser self.ghc-lib-parser-ex_8_10_0_24);

  # has a restrictive lower bound on Cabal
  fourmolu = doJailbreak super.fourmolu;

  # OneTuple needs hashable (instead of ghc-prim) and foldable1-classes-compat for GHC < 9
  OneTuple = addBuildDepends [
    self.foldable1-classes-compat
  ] (super.OneTuple.override {
    ghc-prim = self.hashable;
  });

  # Temporarily disabled blaze-textual for GHC >= 9.0 causing hackage2nix ignoring it
  # https://github.com/paul-rouse/mysql-simple/blob/872604f87044ff6d1a240d9819a16c2bdf4ed8f5/Database/MySQL/Internal/Blaze.hs#L4-L10
  mysql-simple = addBuildDepends [
    self.blaze-textual
  ] super.mysql-simple;

  # https://github.com/fpco/inline-c/issues/127 (recommend to upgrade to Nixpkgs GHC >=9.0)
  inline-c-cpp = (if isDarwin then dontCheck else x: x) super.inline-c-cpp;

  # Depends on OneTuple for GHC < 9.0
  universe-base = addBuildDepends [ self.OneTuple ] super.universe-base;

  # doctest-parallel dependency requires newer Cabal
  regex-tdfa = dontCheck super.regex-tdfa;

  # Unnecessarily strict lower bound on base
  # https://github.com/mrkkrp/megaparsec/pull/485#issuecomment-1250051823
  megaparsec = doJailbreak super.megaparsec;

  # Needs OneTuple for ghc < 9.2
  binary-orphans = addBuildDepends [ self.OneTuple ] super.binary-orphans;

  # Later versions only support GHC >= 9.2
  ghc-exactprint = self.ghc-exactprint_0_6_4;
  apply-refact = self.apply-refact_0_9_3_0;

  # Requires GHC < 9.4
  ghc-source-gen = doDistribute (unmarkBroken super.ghc-source-gen);
}
