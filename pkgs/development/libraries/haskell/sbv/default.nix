{ cabal, deepseq, filepath, HUnit, mtl, QuickCheck, random, syb }:

cabal.mkDerivation (self: {
  pname = "sbv";
  version = "3.0";
  sha256 = "16k9f0x4amg7mm8ib22nyk1rngrbf9311gl2m15hbdq49jp8ik9i";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    deepseq filepath HUnit mtl QuickCheck random syb
  ];
  testDepends = [ filepath HUnit syb ];
  meta = {
    homepage = "http://leventerkok.github.com/sbv/";
    description = "SMT Based Verification: Symbolic Haskell theorem prover using SMT solving";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
