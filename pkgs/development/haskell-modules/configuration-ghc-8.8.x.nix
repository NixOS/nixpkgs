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
  terminfo = if pkgs.stdenv.hostPlatform == pkgs.stdenv.buildPlatform then null else self.terminfo_0_4_1_5;
  text = null;
  time = null;
  transformers = null;
  unix = null;
  # GHC only bundles the xhtml library if haddock is enabled, check if this is
  # still the case when updating: https://gitlab.haskell.org/ghc/ghc/-/blob/0198841877f6f04269d6050892b98b5c3807ce4c/ghc.mk#L463
  xhtml = if self.ghc.hasHaddock or true then null else self.xhtml_3000_2_2_1;

  # GHC 8.8.x can build haddock version 2.23.*
  haddock = self.haddock_2_23_1;
  haddock-api = self.haddock-api_2_23_1;

  # This build needs a newer version of Cabal.
  cabal2spec = super.cabal2spec.override { Cabal = self.Cabal_3_2_1_0; };

  # cabal-install needs more recent versions of Cabal and random, but an older
  # version of base16-bytestring.
  cabal-install = super.cabal-install.overrideScope (self: super: {
    Cabal = self.Cabal_3_6_3_0;
  });

  # Ignore overly restrictive upper version bounds.
  aeson-diff = doJailbreak super.aeson-diff;
  async = doJailbreak super.async;
  ChasingBottoms = doJailbreak super.ChasingBottoms;
  chell = doJailbreak super.chell;
  Diff = dontCheck super.Diff;
  doctest = doJailbreak super.doctest;
  hashable = doJailbreak super.hashable;
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
  foundation = dontCheck super.foundation;
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

  # cabal-fmt requires Cabal3
  cabal-fmt = super.cabal-fmt.override { Cabal = self.Cabal_3_2_1_0; };

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

  # This became a core library in ghc 8.10., so we don‘t have an "exception" attribute anymore.
  exceptions = super.exceptions_0_10_5;

  # ghc versions which don‘t match the ghc-lib-parser-ex version need the
  # additional dependency to compile successfully.
  ghc-lib-parser-ex = addBuildDepend self.ghc-lib-parser super.ghc-lib-parser-ex;

  ormolu = super.ormolu_0_2_0_0;

  # vector 0.12.2 indroduced doctest checks that don‘t work on older compilers
  vector = dontCheck super.vector;

  ghc-api-compat = doDistribute super.ghc-api-compat_8_6;

  mime-string = disableOptimization super.mime-string;

  # Older compilers need the latest ghc-lib to build this package.
  hls-hlint-plugin = addBuildDepend self.ghc-lib (overrideCabal (drv: {
      # Workaround for https://github.com/haskell/haskell-language-server/issues/2728
      postPatch = ''
        sed -i 's/(GHC.RealSrcSpan x,/(GHC.RealSrcSpan x Nothing,/' src/Ide/Plugin/Hlint.hs
      '';
    })
     super.hls-hlint-plugin);

  haskell-language-server = appendConfigureFlags [
      "-f-stylishhaskell"
      "-f-brittany"
    ]
  super.haskell-language-server;

  # has a restrictive lower bound on Cabal
  fourmolu = doJailbreak super.fourmolu;

  # OneTuple needs hashable instead of ghc-prim for GHC < 9
  OneTuple = super.OneTuple.override {
    ghc-prim = self.hashable;
  };

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
}
