{ cabal, HUnit, mtl, testFramework, testFrameworkHunit, text }:

cabal.mkDerivation (self: {
  pname = "digestive-functors";
  version = "0.6.0.1";
  sha256 = "1ni1hfmpz14yvgjphwz64hqhg7xbhvvqbdnapspipplvnl0rcmhi";
  buildDepends = [ mtl text ];
  testDepends = [ HUnit mtl testFramework testFrameworkHunit text ];
  meta = {
    homepage = "http://github.com/jaspervdj/digestive-functors";
    description = "A practical formlet library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
