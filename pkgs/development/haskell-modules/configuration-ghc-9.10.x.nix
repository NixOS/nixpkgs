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
  Win32 = null;

  # “Unfortunately we are unable to support GHC 9.10.”
  apply-refact = dontDistribute (markBroken super.apply-refact);

  #
  # Version upgrades
  #

  # Upgrade to accommodate new core library versions, where the authors have
  # already made the relevant changes.

  #
  # Jailbreaks
  #
  floskell = doJailbreak super.floskell; # base <4.20
  # 2025-04-09: filepath <1.5
  haddock-library =
    assert super.haddock-library.version == "1.11.0";
    doJailbreak super.haddock-library;
  tree-sitter = doJailbreak super.tree-sitter; # containers <0.7, filepath <1.5

  #
  # Test suite issues
  #
  call-stack = dontCheck super.call-stack; # https://github.com/sol/call-stack/issues/19
  monad-dijkstra = dontCheck super.monad-dijkstra; # needs hlint 3.10
}
