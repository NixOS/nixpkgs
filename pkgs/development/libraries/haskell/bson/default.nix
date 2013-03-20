{ cabal, binary, cryptohash, dataBinaryIeee754, mtl, network
, QuickCheck, testFramework, testFrameworkQuickcheck2, text, time
}:

cabal.mkDerivation (self: {
  pname = "bson";
  version = "0.2.2";
  sha256 = "043lbaj4rrvh4a1yc033np51vi8xlbczflbhyx2bsiryzbi27waf";
  buildDepends = [
    binary cryptohash dataBinaryIeee754 mtl network text time
  ];
  testDepends = [
    binary cryptohash dataBinaryIeee754 mtl network QuickCheck
    testFramework testFrameworkQuickcheck2 text time
  ];
  meta = {
    homepage = "http://github.com/selectel/bson-haskell";
    description = "BSON documents are JSON-like objects with a standard binary encoding";
    license = "unknown";
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
