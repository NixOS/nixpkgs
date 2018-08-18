{ pkgs, haskellLib }:

with haskellLib;

self: super: {

  # This compiler version needs llvm 5.x.
  llvmPackages = pkgs.llvmPackages_5;

  # Disable GHC 8.4.x core libraries.
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
  hpc = null;
  integer-gmp = null;
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

  # https://github.com/jcristovao/enclosed-exceptions/issues/12
  enclosed-exceptions = dontCheck super.enclosed-exceptions;

  # https://github.com/jaor/xmobar/issues/356
  xmobar = super.xmobar.overrideScope (self: super: { hinotify = self.hinotify_0_3_9; });
  hinotify_0_3_9 = dontCheck (doJailbreak super.hinotify_0_3_9); # allow async 2.2.x

}
