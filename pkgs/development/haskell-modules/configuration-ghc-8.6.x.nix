{ pkgs, haskellLib }:

with haskellLib;

self: super: {

  # This compiler version needs llvm 6.x.
  llvmPackages = pkgs.llvmPackages_6;

  # Disable GHC 8.6.x core libraries.
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

  # Needs Cabal 3.0.x.
  cabal-install = super.cabal-install.overrideScope (self: super: { Cabal = self.Cabal_3_0_0_0; });
  jailbreak-cabal = super.jailbreak-cabal.override { Cabal = self.Cabal_3_0_0_0; };

  # https://github.com/tibbe/unordered-containers/issues/214
  unordered-containers = dontCheck super.unordered-containers;

  # Test suite does not compile.
  data-clist = doJailbreak super.data-clist;  # won't cope with QuickCheck 2.12.x
  dates = doJailbreak super.dates; # base >=4.9 && <4.12
  Diff = dontCheck super.Diff;
  equivalence = dontCheck super.equivalence; # test suite doesn't compile https://github.com/pa-ba/equivalence/issues/5
  HaTeX = doJailbreak super.HaTeX; # containers >=0.4 && <0.6 is too tight; https://github.com/Daniel-Diaz/HaTeX/issues/126
  hpc-coveralls = doJailbreak super.hpc-coveralls; # https://github.com/guillaume-nargeot/hpc-coveralls/issues/82
  http-api-data = doJailbreak super.http-api-data;
  persistent-sqlite = dontCheck super.persistent-sqlite;
  system-fileio = dontCheck super.system-fileio;  # avoid dependency on broken "patience"
  unicode-transforms = dontCheck super.unicode-transforms;
  wl-pprint-extras = doJailbreak super.wl-pprint-extras; # containers >=0.4 && <0.6 is too tight; https://github.com/ekmett/wl-pprint-extras/issues/17
  RSA = dontCheck super.RSA; # https://github.com/GaloisInc/RSA/issues/14
  monad-par = dontCheck super.monad-par;  # https://github.com/simonmar/monad-par/issues/66
  github = dontCheck super.github; # hspec upper bound exceeded; https://github.com/phadej/github/pull/341
  binary-orphans = dontCheck super.binary-orphans; # tasty upper bound exceeded; https://github.com/phadej/binary-orphans/commit/8ce857226595dd520236ff4c51fa1a45d8387b33

  # https://github.com/jgm/skylighting/issues/55
  skylighting-core = dontCheck super.skylighting-core;

  # Break out of "yaml >=0.10.4.0 && <0.11": https://github.com/commercialhaskell/stack/issues/4485
  stack = doJailbreak super.stack;

  # Newer versions don't compile.
  resolv = self.resolv_0_1_1_2;

  # cabal2nix needs the latest version of Cabal, and the one
  # hackage-db uses must match, so take the latest
  cabal2nix = super.cabal2nix.overrideScope (self: super: {
    Cabal = self.Cabal_3_0_0_0;
    hackage-db = self.hackage-db_2_1_0;
  });

  # cabal2spec needs a recent version of Cabal
  cabal2spec = super.cabal2spec.overrideScope (self: super: { Cabal = self.Cabal_3_0_0_0; });

  # Builds only with ghc-8.8.x and beyond.
  policeman = markBroken super.policeman;

  # https://github.com/pikajude/stylish-cabal/issues/12
  stylish-cabal = doDistribute (markUnbroken (super.stylish-cabal.override { haddock-library = self.haddock-library_1_7_0; }));
  haddock-library_1_7_0 = dontCheck super.haddock-library_1_7_0;

}
