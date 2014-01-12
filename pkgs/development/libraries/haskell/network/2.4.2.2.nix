{ cabal, HUnit, parsec, testFramework, testFrameworkHunit
, testFrameworkQuickcheck2
}:

cabal.mkDerivation (self: {
  pname = "network";
  version = "2.4.2.2";
  sha256 = "0bxfy6irh5050ykhwfwzl5fnqi74j7x6k4ni7ahw2zwjy3qafc5x";
  buildDepends = [ parsec ];
  testDepends = [
    HUnit testFramework testFrameworkHunit testFrameworkQuickcheck2
  ];
  meta = {
    homepage = "https://github.com/haskell/network";
    description = "Low-level networking interface";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
