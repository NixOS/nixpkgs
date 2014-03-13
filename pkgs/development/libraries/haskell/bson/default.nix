{ cabal, binary, cryptohash, dataBinaryIeee754, mtl, network
, QuickCheck, testFramework, testFrameworkQuickcheck2, text, time
}:

cabal.mkDerivation (self: {
  pname = "bson";
  version = "0.2.4";
  sha256 = "1fr0xx9q2l3cb72j5lgrwdlr2gba7idh2v80s8d6dr69dhwaccd9";
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
