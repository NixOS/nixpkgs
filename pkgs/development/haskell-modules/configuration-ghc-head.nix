##
## Caveat: a copy of configuration-ghc-8.6.x.nix with minor changes:
##
##  1. "8.7" strings
##  2. llvm 6
##  3. disabled library update: parallel
##
{ pkgs, haskellLib }:

with haskellLib;

self: super: {

  llvmPackages = pkgs.llvmPackages_10;

  # Disable GHC 8.7.x core libraries.
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
  ghc-bignum = null;
  ghc-compact = null;
  ghc-heap = null;
  ghci = null;
  ghc-prim = null;
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
  exceptions = null;

  # https://github.com/tibbe/unordered-containers/issues/214
  unordered-containers = dontCheck super.unordered-containers;

  # Test suite does not compile.
  data-clist = doJailbreak super.data-clist;  # won't cope with QuickCheck 2.12.x
  dates = doJailbreak super.dates; # base >=4.9 && <4.12
  Diff = dontCheck super.Diff;
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

  # Fix build with ghc 8.6.x.
  git-annex = appendPatch super.git-annex ./patches/git-annex-fix-ghc-8.6.x-build.patch;

}
