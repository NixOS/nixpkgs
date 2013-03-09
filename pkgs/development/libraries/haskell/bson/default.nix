{ cabal, binary, cryptohash, dataBinaryIeee754, mtl, network
, QuickCheck, testFramework, testFrameworkQuickcheck2, text, time
}:

cabal.mkDerivation (self: {
  pname = "bson";
  version = "0.2.1";
  sha256 = "1g5xvkpn5j2yn9figxiv5dindwv6gg90np56k235hy9cwmdicmwq";
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
