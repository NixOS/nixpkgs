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

  # Needs a recent version from the "develop" branch of the upstream git
  # repository to compile with ghc 8.6.4.
  liquid-fixpoint = assert super.liquid-fixpoint.version == "0.7.0.7"; overrideSrc super.liquid-fixpoint {
    src = pkgs.fetchFromGitHub {
      owner = "ucsd-progsys";
      repo = "liquid-fixpoint";
      rev = "42c027ab9ae47907c588a2f1f9c05a5e0aa881e9";
      sha256 = "17qmzq1vx7h04yd38drr6sh6hys3q2rz62qh3pna9kbxlcnikkqf";
    };
    version = "0.8.0.2-pre-release";
  };
  liquidhaskell = assert super.liquidhaskell.version == "0.8.2.4"; overrideSrc super.liquidhaskell {
    src = pkgs.fetchFromGitHub {
      owner = "ucsd-progsys";
      repo = "liquidhaskell";
      rev = "46f11e8faef006e70d39572d08419283b1280b88";
      sha256 = "10z5r6g5acd43bsak762kwhy33ff262zmhs0wga545nbg29q1fyp";
    };
    version = "0.8.6.0-pre-release";
  };

}
