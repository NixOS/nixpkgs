{ cabal, blazeBuilder, httpTypes, HUnit, mtl, parsec, QuickCheck
, split, testFramework, testFrameworkHunit
, testFrameworkQuickcheck2, testFrameworkTh, text, utf8String
}:

cabal.mkDerivation (self: {
  pname = "web-routes";
  version = "0.27.4";
  sha256 = "1n9gdaxzy22m3fmrq3j1jkm16c4wvffjbh19xckfpva53zdhsal4";
  buildDepends = [
    blazeBuilder httpTypes mtl parsec split text utf8String
  ];
  testDepends = [
    HUnit QuickCheck testFramework testFrameworkHunit
    testFrameworkQuickcheck2 testFrameworkTh
  ];
  meta = {
    description = "Library for maintaining correctness and composability of URLs within an application";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
