{ cabal, deepseq, extensibleExceptions, filepath, HUnit, QuickCheck
, regexPosix, testFramework, testFrameworkHunit
, testFrameworkQuickcheck2, time
}:

cabal.mkDerivation (self: {
  pname = "Cabal";
  version = "1.18.0";
  sha256 = "1nxvkfkjkyxsa4nbrwl59r84j63qh2qx4cbd3vnr6vvdnflbix8f";
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
