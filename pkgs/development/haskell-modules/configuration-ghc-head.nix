{ pkgs }:

with import ./lib.nix { inherit pkgs; };

self: super: {

  # Use the latest LLVM.
  inherit (pkgs) llvmPackages;

  # Disable GHC 7.11.x core libraries.
  array = null;
  base = null;
  binary = null;
  bin-package-db = null;
  bytestring = null;
  Cabal = null;
  containers = null;
  deepseq = null;
  directory = null;
  filepath = null;
  ghc-prim = null;
  haskeline = null;
  hoopl = null;
  hpc = null;
  integer-gmp = null;
  pretty = null;
  process = null;
  rts = null;
  template-haskell = null;
  terminfo = null;
  time = null;
  transformers = null;
  unix = null;
  xhtml = null;

  # Don't use jailbreak built with Cabal 1.22.x because of https://github.com/peti/jailbreak-cabal/issues/9.
  Cabal_1_23_0_0 = overrideCabal super.Cabal_1_22_4_0 (drv: {
    version = "1.23.0.0";
    src = pkgs.fetchFromGitHub {
      owner = "haskell";
      repo = "cabal";
      rev = "fe7b8784ac0a5848974066bdab76ce376ba67277";
      sha256 = "1d70ryz1l49pkr70g8r9ysqyg1rnx84wwzx8hsg6vwnmg0l5am7s";
    };
    jailbreak = false;
    doHaddock = false;
    postUnpack = "sourceRoot+=/Cabal";
  });
  jailbreak-cabal = overrideCabal super.jailbreak-cabal (drv: {
    executableHaskellDepends = [ self.Cabal_1_23_0_0 ];
    preConfigure = "sed -i -e 's/Cabal == 1.20\\.\\*/Cabal >= 1.23/' jailbreak-cabal.cabal";
  });

  # haddock: No input file(s).
  nats = dontHaddock super.nats;
  bytestring-builder = dontHaddock super.bytestring-builder;

  alex = dontCheck super.alex;

  # We have time 1.5
  aeson = disableCabalFlag super.aeson "old-locale";

  # Show works differently for record syntax now, breaking haskell-src-exts' parser tests
  # https://github.com/haskell-suite/haskell-src-exts/issues/224
  haskell-src-exts = dontCheck super.haskell-src-exts;

  # Setup: At least the following dependencies are missing: base <4.8
  hspec-expectations = overrideCabal super.hspec-expectations (drv: {
    patchPhase = "sed -i -e 's|base < 4.8|base|' hspec-expectations.cabal";
  });
  utf8-string = overrideCabal super.utf8-string (drv: {
    patchPhase = "sed -i -e 's|base >= 3 && < 4.8|base|' utf8-string.cabal";
  });

  # bos/attoparsec#92
  attoparsec = dontCheck super.attoparsec;

  # test suite hangs silently for at least 10 minutes
  split = dontCheck super.split;

  # Test suite fails with some (seemingly harmless) error.
  # https://code.google.com/p/scrapyourboilerplate/issues/detail?id=24
  syb = dontCheck super.syb;

  # Test suite has stricter version bounds
  retry = dontCheck super.retry;

  # Test suite fails with time >= 1.5
  http-date = dontCheck super.http-date;

  # Version 1.19.5 fails its test suite.
  happy = dontCheck super.happy;

  # Workaround for a workaround, see comment for "ghcjs" flag.
  jsaddle = let jsaddle' = disableCabalFlag super.jsaddle "ghcjs";
            in addBuildDepends jsaddle' [ self.glib self.gtk3 self.webkitgtk3
                                          self.webkitgtk3-javascriptcore ];

  # The compat library is empty in the presence of mtl 2.2.x.
  mtl-compat = dontHaddock super.mtl-compat;

  # Won't work with LLVM 3.5.
  llvm-general = markBrokenVersion "3.4.5.3" super.llvm-general;

}
