{ cabal, HUnit, mtl, QuickCheck, testFramework, testFrameworkHunit
, testFrameworkQuickcheck2, text, time
}:

cabal.mkDerivation (self: {
  pname = "digestive-functors";
  version = "0.7.0.0";
  sha256 = "1zn8vn6xcmp4w39b0k33bp7zsxvnn8g8p26mch4r8ng9ldcb2y8h";
  buildDepends = [ mtl text time ];
  testDepends = [
    HUnit mtl QuickCheck testFramework testFrameworkHunit
    testFrameworkQuickcheck2 text time
  ];
  meta = {
    homepage = "http://github.com/jaspervdj/digestive-functors";
    description = "A practical formlet library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
