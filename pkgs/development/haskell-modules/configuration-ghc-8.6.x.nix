{ pkgs, haskellLib }:

with haskellLib;

self: super: {

  # This compiler version needs llvm 5.x.
  llvmPackages = pkgs.llvmPackages_5;

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

  # https://github.com/tibbe/unordered-containers/issues/214
  unordered-containers = dontCheck super.unordered-containers;

  # Test suite does not compile.
  cereal = dontCheck super.cereal;
  data-clist = doJailbreak super.data-clist;  # won't cope with QuickCheck 2.12.x
  Diff = dontCheck super.Diff;
  http-api-data = doJailbreak super.http-api-data;
  persistent-sqlite = dontCheck super.persistent-sqlite;
  psqueues = dontCheck super.psqueues;    # won't cope with QuickCheck 2.12.x
  system-fileio = dontCheck super.system-fileio;  # avoid dependency on broken "patience"
  unicode-transforms = dontCheck super.unicode-transforms;
  RSA = dontCheck super.RSA; # https://github.com/GaloisInc/RSA/issues/14
  monad-par = dontCheck super.monad-par;  # https://github.com/simonmar/monad-par/issues/66

  # https://github.com/jgm/skylighting/issues/55
  skylighting-core = dontCheck super.skylighting-core;

  # Break out of "yaml >=0.10.4.0 && <0.11": https://github.com/commercialhaskell/stack/issues/4485
  stack = doJailbreak super.stack;

  # Break out of "tasty >= 0.11 && < 1.2": https://github.com/jgm/pandoc/issues/5200
  pandoc = doJailbreak super.pandoc;

}
