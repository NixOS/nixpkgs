{ cabal, aeson, certificate, conduit, cryptoApi, cryptoRandomApi
, network, networkConduit, pem, systemFileio, systemFilepath, tls
, tlsExtra, transformers
}:

cabal.mkDerivation (self: {
  pname = "network-conduit-tls";
  version = "1.0.1";
  sha256 = "0h2svqllm85vambssq0j4ghx2b44cjg0kj04bamp72ly22mcg9d6";
  buildDepends = [
    aeson certificate conduit cryptoApi cryptoRandomApi network
    networkConduit pem systemFileio systemFilepath tls tlsExtra
    transformers
  ];
  meta = {
    homepage = "https://github.com/snoyberg/conduit";
    description = "Create TLS-aware network code with conduits";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
