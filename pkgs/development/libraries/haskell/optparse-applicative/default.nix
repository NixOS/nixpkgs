{ cabal, HUnit, testFramework, testFrameworkHunit
, testFrameworkThPrime, transformers
}:

cabal.mkDerivation (self: {
  pname = "optparse-applicative";
  version = "0.7.0";
  sha256 = "1mhf9jrkznd2aq11610rkss09i9q33i9f97f492z854bp86pfkk8";
  buildDepends = [ transformers ];
  testDepends = [
    HUnit testFramework testFrameworkHunit testFrameworkThPrime
  ];
  jailbreak = true;
  meta = {
    homepage = "https://github.com/pcapriotti/optparse-applicative";
    description = "Utilities and combinators for parsing command line options";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
