{ pkgs, haskellLib }:

with haskellLib;

let
  inherit (pkgs.stdenv.hostPlatform) isDarwin;
in

self: super: {

  llvmPackages = pkgs.lib.dontRecurseIntoAttrs self.ghc.llvmPackages;

  # Disable GHC core libraries.
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
  system-cxx-std-lib = null;
  template-haskell = null;
  # GHC only builds terminfo if it is a native compiler
  terminfo = if pkgs.stdenv.hostPlatform == pkgs.stdenv.buildPlatform then null else self.terminfo_0_4_1_6;
  text = null;
  time = null;
  transformers = null;
  unix = null;
  xhtml = null;

  alex = super.alex_3_4_0_1;
  # ghc-lib 9.8.1.20231121 required for Cabal to build: https://github.com/digital-asset/ghc-lib/issues/495
  ghc-lib = super.ghc-lib_9_8_1_20231121;
  ghc-lib-parser = super.ghc-lib-parser_9_8_1_20231121;
  github = super.github_0_29;
  some = super.some_1_0_6;
  tagged = some.tagged_0_8_8;

  # https://github.com/obsidiansystems/commutative-semigroups/issues/13
  commutative-semigroups = doJailbreak super.commutative-semigroups;

  # https://github.com/maoe/ghc-trace-events/issues/12
  ghc-trace-events = doJailbreak super.ghc-trace-events;

  generic-lens-core = doJailbreak super.generic-lens-core; # text >= 1.2 && < 1.3 || >= 2.0 && < 2.1

  # Test suite does not compile.
  dates = doJailbreak super.dates; # base >=4.9 && <4.16
  hpc-coveralls = doJailbreak super.hpc-coveralls; # https://github.com/guillaume-nargeot/hpc-coveralls/issues/82
  persistent-sqlite = dontCheck super.persistent-sqlite;
  system-fileio = dontCheck super.system-fileio;  # avoid dependency on broken "patience"
  wl-pprint-extras = doJailbreak super.wl-pprint-extras; # containers >=0.4 && <0.6 is too tight; https://github.com/ekmett/wl-pprint-extras/issues/17
}
