{ pkgs, haskellLib }:

let
  inherit (pkgs) lib;
in

with haskellLib;

self: super: {
  llvmPackages = lib.dontRecurseIntoAttrs self.ghc.llvmPackages;

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
      haskellLib.doDistribute self.terminfo_0_4_1_6;
  text = null;
  time = null;
  transformers = null;
  unix = null;
  xhtml = null;

  doctest = self.doctest_0_23_0;
  htree = doDistribute self.htree_0_2_0_0;
  tagged = doDistribute self.tagged_0_8_9;
  time-compat = doDistribute (doJailbreak self.time-compat_1_9_8); # too strict lower bound on QuickCheck
  ghc-syntax-highlighter = doDistribute self.ghc-syntax-highlighter_0_0_13_0;
  ghc-lib-parser = doDistribute self.ghc-lib-parser_9_12_1_20250105;
  ghc-lib = doDistribute self.ghc-lib_9_12_1_20250105;

  #
  # Jailbreaks
  #
  lucid = doJailbreak super.lucid; # base <4.21
  ed25519 = doJailbreak super.ed25519; # https://github.com/thoughtpolice/hs-ed25519/issues/39
  servant = doJailbreak super.servant; # base < 4.21

  # Test suite issues
  call-stack = dontCheck super.call-stack; # https://github.com/sol/call-stack/issues/19

  # Cabal 3.14 regression (incorrect datadir in tests): https://github.com/haskell/cabal/issues/10717
  alex = overrideCabal (drv: {
    preCheck =
      drv.preCheck or ""
      + ''
        export alex_datadir="$(pwd)/data"
      '';
  }) super.alex;
}
