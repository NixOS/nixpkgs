{ cabal, ansiWlPprint, HUnit, QuickCheck, testFramework
, testFrameworkHunit, testFrameworkQuickcheck2
, testFrameworkThPrime, transformers
}:

cabal.mkDerivation (self: {
  pname = "optparse-applicative";
  version = "0.8.0.1";
  sha256 = "19k7jw9hrns5i8dr67jxadaqnj0cmn991hl00fwymg4awv34p1w3";
  buildDepends = [ ansiWlPprint transformers ];
  testDepends = [
    HUnit QuickCheck testFramework testFrameworkHunit
    testFrameworkQuickcheck2 testFrameworkThPrime
  ];
  jailbreak = true;
  meta = {
    homepage = "https://github.com/pcapriotti/optparse-applicative";
    description = "Utilities and combinators for parsing command line options";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
