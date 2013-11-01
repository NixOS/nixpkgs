{ cabal, ChasingBottoms, deepseq, hashable, HUnit, QuickCheck
, testFramework, testFrameworkHunit, testFrameworkQuickcheck2
}:

cabal.mkDerivation (self: {
  pname = "unordered-containers";
  version = "0.2.3.3";
  sha256 = "09sn19fk4smhf4zi3326wy2a62lh231k2nm8jd64j51arch42sdi";
  buildDepends = [ deepseq hashable ];
  testDepends = [
    ChasingBottoms hashable HUnit QuickCheck testFramework
    testFrameworkHunit testFrameworkQuickcheck2
  ];
  doCheck = false;
  meta = {
    homepage = "https://github.com/tibbe/unordered-containers";
    description = "Efficient hashing-based container types";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
