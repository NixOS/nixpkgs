{ cabal, binary, cryptohash, dataBinaryIeee754, mtl, network, text
, time
}:

cabal.mkDerivation (self: {
  pname = "bson";
  version = "0.2.0";
  sha256 = "1m4bzbl3i9p8v78zjb4ilrpdxbxpqz5bgcpklvvkb2ipfkgqhmhx";
  buildDepends = [
    binary cryptohash dataBinaryIeee754 mtl network text time
  ];
  meta = {
    homepage = "http://github.com/selectel/bson-haskell";
    description = "BSON documents are JSON-like objects with a standard binary encoding";
    license = "unknown";
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
