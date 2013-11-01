{ cabal, deepseq, extensibleExceptions, filepath, HUnit, QuickCheck
, regexPosix, testFramework, testFrameworkHunit
, testFrameworkQuickcheck2, time
}:

cabal.mkDerivation (self: {
  pname = "Cabal";
  version = "1.18.1.2";
  sha256 = "0pbg9d40lskcps248fdcnm4hnib3vl10mbcdf830zw45q29gfkjr";
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
