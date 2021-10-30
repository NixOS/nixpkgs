{ pkgs, haskellLib }:

with haskellLib;

self: super: {

  # This compiler version needs llvm 7.x.
  llvmPackages = pkgs.lib.dontRecurseIntoAttrs pkgs.llvmPackages_7;

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
  terminfo = null;
  text = null;
  time = null;
  transformers = null;
  unix = null;
  xhtml = null;

  # GHC 8.8.x can build haddock version 2.23.*
  haddock = self.haddock_2_23_1;
  haddock-api = self.haddock-api_2_23_1;

  # This build needs a newer version of Cabal.
  cabal2spec = super.cabal2spec.override { Cabal = self.Cabal_3_2_1_0; };

  # cabal-install needs more recent versions of Cabal and random, but an older
  # version of base16-bytestring.
  cabal-install = super.cabal-install.overrideScope (self: super: {
    Cabal = self.Cabal_3_6_2_0;
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
  snap-core = overrideCabal super.snap-core (drv: { prePatch = "substituteInPlace src/Snap/Internal/Core.hs --replace 'fail   = Fail.fail' ''"; });

  # Upstream ships a broken Setup.hs file.
  csv = overrideCabal super.csv (drv: { prePatch = "rm Setup.hs"; });

  # https://github.com/kowainik/relude/issues/241
  relude = dontCheck super.relude;

  # The current version 2.14.2 does not compile with ghc-8.8.x or newer because
  # of issues with Cabal 3.x.
  darcs = dontDistribute super.darcs;

  # The package needs the latest Cabal version.
  cabal-install-parsers = super.cabal-install-parsers.overrideScope (self: super: { Cabal = self.Cabal_3_6_2_0; });

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
  exceptions = super.exceptions_0_10_4;

  # ghc versions which don‘t match the ghc-lib-parser-ex version need the
  # additional dependency to compile successfully.
  ghc-lib-parser-ex = addBuildDepend super.ghc-lib-parser-ex self.ghc-lib-parser;

  # Older compilers need the latest ghc-lib to build this package.
  hls-hlint-plugin = addBuildDepend super.hls-hlint-plugin self.ghc-lib;

  # vector 0.12.2 indroduced doctest checks that don‘t work on older compilers
  vector = dontCheck super.vector;

  ghc-api-compat = doDistribute super.ghc-api-compat_8_6;
}
