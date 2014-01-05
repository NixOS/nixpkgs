{ cabal, deepseq, HUnit, QuickCheck, random, testFramework
, testFrameworkHunit, testFrameworkQuickcheck2
}:

cabal.mkDerivation (self: {
  pname = "text";
  version = "1.0.0.0";
  sha256 = "13i7xn5xl8lc5hcd08i4n0qp9rx51588jnjn4c68gp87vw1gwvjn";
  buildDepends = [ deepseq ];
  testDepends = [
    deepseq HUnit QuickCheck random testFramework testFrameworkHunit
    testFrameworkQuickcheck2
  ];
  doCheck = false;
  meta = {
    homepage = "https://github.com/bos/text";
    description = "An efficient packed Unicode text type";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
