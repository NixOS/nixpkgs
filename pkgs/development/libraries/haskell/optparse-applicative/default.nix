{ cabal, HUnit, testFramework, testFrameworkHunit
, testFrameworkThPrime, transformers
}:

cabal.mkDerivation (self: {
  pname = "optparse-applicative";
  version = "0.6.0";
  sha256 = "07wzsgwym0g6qd39jvgp6ndpqdn2w0c4sn9mcz19rqlb2am24ip8";
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
