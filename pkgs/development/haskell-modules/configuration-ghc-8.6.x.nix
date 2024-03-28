{ pkgs, haskellLib }:

with haskellLib;

let
  inherit (pkgs.stdenv.hostPlatform) isDarwin;
in

self: super: {

  # Should be llvmPackages_6 which has been removed from nixpkgs
  llvmPackages = null;

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
  # GHC only builds terminfo if it is a native compiler
  terminfo = if pkgs.stdenv.hostPlatform == pkgs.stdenv.buildPlatform then null else doDistribute self.terminfo_0_4_1_6;
  text = null;
  time = null;
  transformers = null;
  unix = null;
  # GHC only bundles the xhtml library if haddock is enabled, check if this is
  # still the case when updating: https://gitlab.haskell.org/ghc/ghc/-/blob/0198841877f6f04269d6050892b98b5c3807ce4c/ghc.mk#L463
  xhtml = if self.ghc.hasHaddock or true then null else doDistribute self.xhtml_3000_3_0_0;

  # Need the Cabal-syntax-3.6.0.0 fake package for Cabal < 3.8 to allow callPackage and the constraint solver to work
  Cabal-syntax = self.Cabal-syntax_3_6_0_0;
  # These core package only exist for GHC >= 9.4. The best we can do is feign
  # their existence to callPackages, but their is no shim for lower GHC versions.
  system-cxx-std-lib = null;

  # Needs Cabal 3.0.x.
  jailbreak-cabal = super.jailbreak-cabal.overrideScope (cself: _: { Cabal = cself.Cabal_3_2_1_0; });

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
  github = dontCheck super.github; # hspec upper bound exceeded; https://github.com/phadej/github/pull/341
  binary-orphans = dontCheck super.binary-orphans; # tasty upper bound exceeded; https://github.com/phadej/binary-orphans/commit/8ce857226595dd520236ff4c51fa1a45d8387b33
  rebase = doJailbreak super.rebase; # time ==1.9.* is too low

  # https://github.com/jgm/skylighting/issues/55
  skylighting-core = dontCheck super.skylighting-core;

  # cabal2nix needs the latest version of Cabal, and the one
  # hackage-db uses must match, so take the latest
  cabal2nix = super.cabal2nix.overrideScope (self: super: { Cabal = self.Cabal_3_2_1_0; });

  # cabal2spec needs a recent version of Cabal
  cabal2spec = super.cabal2spec.overrideScope (self: super: { Cabal = self.Cabal_3_2_1_0; });

  # https://github.com/pikajude/stylish-cabal/issues/12
  stylish-cabal = doDistribute (markUnbroken (super.stylish-cabal.override { haddock-library = self.haddock-library_1_7_0; }));
  haddock-library_1_7_0 = dontCheck super.haddock-library_1_7_0;

  # ghc versions prior to 8.8.x needs additional dependency to compile successfully.
  ghc-lib-parser-ex = addBuildDepend self.ghc-lib-parser super.ghc-lib-parser-ex;

  # This became a core library in ghc 8.10., so we don’t have an "exception" attribute anymore.
  exceptions = self.exceptions_0_10_7;

  # vector 0.12.2 indroduced doctest checks that don’t work on older compilers
  vector = dontCheck super.vector;

  mmorph = super.mmorph_1_1_3;

  # https://github.com/haskellari/time-compat/issues/23
  time-compat = dontCheck super.time-compat;

  mime-string = disableOptimization super.mime-string;

  # https://github.com/fpco/inline-c/issues/127 (recommend to upgrade to Nixpkgs GHC >=9.0)
  inline-c-cpp = (if isDarwin then dontCheck else x: x) super.inline-c-cpp;
}
