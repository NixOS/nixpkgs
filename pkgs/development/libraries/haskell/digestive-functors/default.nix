{ cabal, HUnit, mtl, QuickCheck, testFramework, testFrameworkHunit
, testFrameworkQuickcheck2, text
}:

cabal.mkDerivation (self: {
  pname = "digestive-functors";
  version = "0.6.1.1";
  sha256 = "05px6xal6kzppph5nm9w60vsdz0d9gng8zp26ipwpxzk57jg4jjw";
  buildDepends = [ mtl text ];
  testDepends = [
    HUnit mtl QuickCheck testFramework testFrameworkHunit
    testFrameworkQuickcheck2 text
  ];
  jailbreak = true;
  meta = {
    homepage = "http://github.com/jaspervdj/digestive-functors";
    description = "A practical formlet library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
