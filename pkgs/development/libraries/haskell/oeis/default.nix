{ cabal, HTTP, HUnit, network, testFramework, testFrameworkHunit }:

cabal.mkDerivation (self: {
  pname = "oeis";
  version = "0.3.4";
  sha256 = "15xn7cybk43lk8wjd22l3zwvkyrmlixpfyrxsy3rnvh0vmn0r25d";
  buildDepends = [ HTTP network ];
  testDepends = [ HUnit testFramework testFrameworkHunit ];
  meta = {
    description = "Interface to the Online Encyclopedia of Integer Sequences (OEIS)";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
