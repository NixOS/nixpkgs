{ pkgs, haskellLib }:

self: super:

with haskellLib;

let
  inherit (pkgs) lib;

  warnAfterVersion =
    ver: pkg:
    lib.warnIf (lib.versionOlder ver
      super.${pkg.pname}.version
    ) "override for haskell.packages.ghc910.${pkg.pname} may no longer be needed" pkg;

in

{
  # Disable GHC core libraries
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
  ghc-experimental = null;
  ghc-heap = null;
  ghc-internal = null;
  ghc-platform = null;
  ghc-prim = null;
  ghc-toolchain = null;
  ghci = null;
  haskeline = null;
  hpc = null;
  integer-gmp = null;
  mtl = null;
  os-string = null;
  parsec = null;
  pretty = null;
  process = null;
  rts = null;
  semaphore-compat = null;
  stm = null;
  system-cxx-std-lib = null;
  template-haskell = null;
  # GHC only builds terminfo if it is a native compiler
  terminfo =
    if pkgs.stdenv.hostPlatform == pkgs.stdenv.buildPlatform then
      null
    else
      doDistribute self.terminfo_0_4_1_7;
  text = null;
  time = null;
  transformers = null;
  unix = null;
  xhtml = null;

  #
  # Version upgrades
  #

  # Upgrade to accommodate new core library versions, where the authors have
  # already made the relevant changes.
  # 2025-04-09: jailbreak to allow hedgehog >= 1.5, hspec-hedgehog >=0.2
  extensions = doJailbreak (doDistribute self.extensions_0_1_0_2);
  fourmolu = doDistribute self.fourmolu_0_16_0_0;
  # https://github.com/digital-asset/ghc-lib/issues/600
  ghc-lib = doDistribute self.ghc-lib_9_10_2_20250515;
  ghc-lib-parser = doDistribute self.ghc-lib-parser_9_10_2_20250515;
  ghc-lib-parser-ex = doDistribute self.ghc-lib-parser-ex_9_10_0_0;
  htree = doDistribute self.htree_0_2_0_0;
  ormolu = doDistribute self.ormolu_0_7_7_0;
  stylish-haskell = doDistribute self.stylish-haskell_0_15_0_1;

  # A given major version of ghc-exactprint only supports one version of GHC.
  ghc-exactprint = doDistribute self.ghc-exactprint_1_9_0_0;
  ghc-exactprint_1_9_0_0 = addBuildDepends [
    self.Diff
    self.extra
    self.ghc-paths
    self.silently
    self.syb
    self.HUnit
  ] super.ghc-exactprint_1_9_0_0;

  #
  # Jailbreaks
  #
  # 2025-04-09: base <4.20, containers <0.7, filepath <1.5, Cabal-syntax <3.11
  cabal-install-parsers =
    assert super.cabal-install-parsers.version == "0.6.1.1";
    doJailbreak super.cabal-install-parsers;
  floskell = doJailbreak super.floskell; # base <4.20
  # 2025-04-09: filepath <1.5
  haddock-library =
    assert super.haddock-library.version == "1.11.0";
    doJailbreak super.haddock-library;
  large-generics = doJailbreak super.large-generics; # base <4.20
  tree-sitter = doJailbreak super.tree-sitter; # containers <0.7, filepath <1.5

  hashable_1_5_0_0 = doJailbreak super.hashable_1_5_0_0; # relax bounds for QuickCheck, tasty, and tasty-quickcheck

  #
  # Test suite issues
  #
  call-stack = dontCheck super.call-stack; # https://github.com/sol/call-stack/issues/19
  fsnotify = dontCheck super.fsnotify; # https://github.com/haskell-fswatch/hfsnotify/issues/115
  hinotify = pkgs.haskell.lib.dontCheck super.hinotify; # https://github.com/kolmodin/hinotify/issues/38
  monad-dijkstra = dontCheck super.monad-dijkstra; # needs hlint 3.10

  haskell-language-server = super.haskell-language-server.override {
    floskell = null;
    retrie = null;
    hlint = null;
    apply-refact = null;
  };

}
