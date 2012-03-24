{ cabal, binary, compactStringFix, cryptohash, dataBinaryIeee754
, mtl, network, time
}:

cabal.mkDerivation (self: {
  pname = "bson";
  version = "0.1.7";
  sha256 = "1dmndq0rx22h9kxv31rxwqhwkgsvqg9qy4l0xmvpcvvl101zj4jx";
  buildDepends = [
    binary compactStringFix cryptohash dataBinaryIeee754 mtl network
    time
  ];
  meta = {
    homepage = "http://github.com/TonyGen/bson-haskell";
    description = "BSON documents are JSON-like objects with a standard binary encoding";
    license = "unknown";
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
