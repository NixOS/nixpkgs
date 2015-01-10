{ pkgs }:

with import ./lib.nix { inherit pkgs; };

self: super: {

  # Disable GHC 7.9.x core libraries.
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

  # We have Cabal 1.22.x.
  jailbreak-cabal = super.jailbreak-cabal.override { Cabal = null; };

  # GHC 7.10.x's Haddock binary cannot generate hoogle files.
  # https://ghc.haskell.org/trac/ghc/ticket/9921
  mkDerivation = drv: super.mkDerivation (drv // { doHoogle = false; });

  # haddock: No input file(s).
  nats = dontHaddock super.nats;

  # These used to be core packages in GHC 7.8.x.
  old-locale = self.old-locale_1_0_0_7;
  old-time = self.old-time_1_1_0_3;

  # We have transformers 4.x
  mtl = self.mtl_2_2_1;
  transformers-compat = disableCabalFlag super.transformers-compat "three";

  # We have time 1.5
  aeson = disableCabalFlag super.aeson "old-locale";

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

  # Version 1.19.5 fails its test suite.
  happy = dontCheck super.happy;

  # Test suite hangs silently without consuming any CPU.
  # https://github.com/ndmitchell/extra/issues/4
  extra = dontCheck super.extra;

}
// {
  # Not on Hackage yet.
  doctest = self.mkDerivation {
    pname = "doctest";
    version = "0.9.11.1";
    src = pkgs.fetchgit {
      url = "git://github.com/sol/doctest.git";
      sha256 = "a01ced437f5d733f916dc62ea6a67e0e5d275164ba317da33245cf9374f23925";
      rev = "c85fdaaa92d1f0334d835254d63bdc30f7077387";
    };
    isLibrary = true;
    isExecutable = true;
    doCheck = false;
    buildDepends = with self; [
      base deepseq directory filepath ghc ghc-paths process syb
      transformers
    ];
    testDepends = with self; [
      base base-compat deepseq directory filepath ghc ghc-paths hspec
      HUnit process QuickCheck setenv silently stringbuilder syb
      transformers
    ];
    homepage = "https://github.com/sol/doctest#readme";
    description = "Test interactive Haskell examples";
    license = pkgs.stdenv.lib.licenses.mit;
  };
}
