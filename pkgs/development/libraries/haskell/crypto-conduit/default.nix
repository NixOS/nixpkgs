{ cabal, cereal, conduit, cryptoApi, transformers }:

cabal.mkDerivation (self: {
  pname = "crypto-conduit";
  version = "0.3.0.1";
  sha256 = "1j7j1ga9in9j9i5gxdkpijarcw7a0y8w0z4sj00d2yzb1qhdalzq";
  buildDepends = [ cereal conduit cryptoApi transformers ];
  meta = {
    homepage = "https://github.com/meteficha/crypto-conduit";
    description = "Conduit interface for cryptographic operations (from crypto-api)";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
