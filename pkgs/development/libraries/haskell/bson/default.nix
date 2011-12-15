{ cabal, binary, compactStringFix, cryptohash, dataBinaryIeee754
, mtl, network, time
}:

cabal.mkDerivation (self: {
  pname = "bson";
  version = "0.1.6";
  sha256 = "0w9dab8x6b3dwk2afy0gnmrvcvx2dshwhjvlr2k69nchid4wh823";
  buildDepends = [
    binary compactStringFix cryptohash dataBinaryIeee754 mtl network
    time
  ];
  meta = {
    homepage = "http://github.com/TonyGen/bson-haskell";
    description = "BSON documents are JSON-like objects with a standard binary encoding";
    license = "unknown";
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
