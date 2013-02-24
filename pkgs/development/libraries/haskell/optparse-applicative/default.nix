{ cabal, HUnit, testFramework, testFrameworkHunit
, testFrameworkThPrime, transformers
}:

cabal.mkDerivation (self: {
  pname = "optparse-applicative";
  version = "0.5.2.1";
  sha256 = "0w4mk851mx8dch8lnck0g82asmzrsc47xrf34jygh0f6v4kbj40i";
  buildDepends = [ transformers ];
  testDepends = [
    HUnit testFramework testFrameworkHunit testFrameworkThPrime
  ];
  meta = {
    homepage = "https://github.com/pcapriotti/optparse-applicative";
    description = "Utilities and combinators for parsing command line options";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
