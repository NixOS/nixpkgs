{ cabal, blazeBuilder, httpTypes, HUnit, mtl, parsec, QuickCheck
, split, testFramework, testFrameworkHunit
, testFrameworkQuickcheck2, testFrameworkTh, text, utf8String
}:

cabal.mkDerivation (self: {
  pname = "web-routes";
  version = "0.27.5";
  sha256 = "1jx5wwmlylwrf45wy3w29ck1p7509mgy8m02vipd8apibx6ghp22";
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
