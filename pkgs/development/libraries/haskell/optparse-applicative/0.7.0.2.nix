{ cabal, ansiWlPprint, HUnit, QuickCheck, testFramework
, testFrameworkHunit, testFrameworkQuickcheck2
, testFrameworkThPrime, transformers, transformersCompat
}:

cabal.mkDerivation (self: {
  pname = "optparse-applicative";
  version = "0.7.0.2";
  sha256 = "1pq620236x8fch9nkq4g4vganbzksnwj8z1bb80c2mwvf6sbg5ci";
  buildDepends = [ ansiWlPprint transformers transformersCompat ];
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
