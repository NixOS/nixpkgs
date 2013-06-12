{ cabal, ChasingBottoms, deepseq, hashable, HUnit, QuickCheck
, testFramework, testFrameworkHunit, testFrameworkQuickcheck2
}:

cabal.mkDerivation (self: {
  pname = "unordered-containers";
  version = "0.2.3.1";
  sha256 = "10wz5y42r9b2ym7vl5sqrcawyjixmhy370h0kzpvczs8mlzvrlx8";
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
