{ cabal, extensibleExceptions, filepath, HUnit, QuickCheck
, testFramework, testFrameworkHunit, testFrameworkQuickcheck2
}:

cabal.mkDerivation (self: {
  pname = "Cabal";
  version = "1.14.0";
  sha256 = "1r5b4x1ham5gdg9m9l8idpvr9czlk1q21vqmg0di4adkp2fhlm3j";
  buildDepends = [ filepath ];
  testDepends = [
    extensibleExceptions filepath HUnit QuickCheck testFramework
    testFrameworkHunit testFrameworkQuickcheck2
  ];
  meta = {
    homepage = "http://www.haskell.org/cabal/";
    description = "A framework for packaging Haskell software";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
