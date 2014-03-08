{ cabal, deepseq, extensibleExceptions, filepath, HUnit, QuickCheck
, regexPosix, testFramework, testFrameworkHunit
, testFrameworkQuickcheck2, time
}:

cabal.mkDerivation (self: {
  pname = "Cabal";
  version = "1.18.1.3";
  sha256 = "1m1m6f00sc4w0s5hnqy2z05rnaihaw1jy03bidc5pl6r1llkdi15";
  buildDepends = [ deepseq filepath time ];
  testDepends = [
    extensibleExceptions filepath HUnit QuickCheck regexPosix
    testFramework testFrameworkHunit testFrameworkQuickcheck2
  ];
  doCheck = false;
  meta = {
    homepage = "http://www.haskell.org/cabal/";
    description = "A framework for packaging Haskell software";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
