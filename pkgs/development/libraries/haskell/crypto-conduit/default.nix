{ cabal, cereal, conduit, cryptoApi, cryptocipher, cryptohash
, hspec, skein, transformers
}:

cabal.mkDerivation (self: {
  pname = "crypto-conduit";
  version = "0.5.0";
  sha256 = "0mlf2l784w0wyfjqsxzfdwmn1wb0z1s6mb8kdhw8x1z4a8gy9a92";
  buildDepends = [ cereal conduit cryptoApi transformers ];
  testDepends = [
    cereal conduit cryptoApi cryptocipher cryptohash hspec skein
    transformers
  ];
  meta = {
    homepage = "https://github.com/meteficha/crypto-conduit";
    description = "Conduit interface for cryptographic operations (from crypto-api)";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
