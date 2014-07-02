{ cabal, binary, cryptohash, dataBinaryIeee754, mtl, network
, QuickCheck, testFramework, testFrameworkQuickcheck2, text, time
}:

cabal.mkDerivation (self: {
  pname = "bson";
  version = "0.3";
  sha256 = "0787z6970lf93mgrsyqcilnkx5bynny88ag15z2f07l1rhva6ac4";
  buildDepends = [
    binary cryptohash dataBinaryIeee754 mtl network text time
  ];
  testDepends = [
    binary cryptohash dataBinaryIeee754 mtl network QuickCheck
    testFramework testFrameworkQuickcheck2 text time
  ];
  doCheck = false;
  meta = {
    homepage = "http://github.com/selectel/bson-haskell";
    description = "BSON documents are JSON-like objects with a standard binary encoding";
    license = "unknown";
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
