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

  # Version upgrades
  jailbreak-cabal = overrideCabal {
    # Manually update jailbreak-cabal to 1.4.1 (which supports Cabal >= 3.14)
    # since Hackage bump containing it is tied up in the update to Stackage LTS 23.
    version = "1.4.1";
    sha256 = "0q6l608m965s6932xabm7v2kav5cxrihb5qcbrwz0c4xiwrz4l5x";

    revision = null;
    editedCabalFile = null;
  } super.jailbreak-cabal;
  htree = doDistribute self.htree_0_2_0_0;
  primitive = doDistribute self.primitive_0_9_0_0;
  splitmix = doDistribute self.splitmix_0_1_1;
  tagged = doDistribute self.tagged_0_8_9;
  tar = doDistribute self.tar_0_6_3_0;

  # Test suite issues
  call-stack = dontCheck super.call-stack; # https://github.com/sol/call-stack/issues/19
}
