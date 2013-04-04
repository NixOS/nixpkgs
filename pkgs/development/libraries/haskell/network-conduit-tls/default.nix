{ cabal, aeson, certificate, conduit, cryptoApi, cryptoRandomApi
, network, networkConduit, pem, systemFileio, systemFilepath, tls
, tlsExtra, transformers
}:

cabal.mkDerivation (self: {
  pname = "network-conduit-tls";
  version = "1.0.0.1";
  sha256 = "1bfb888j7raan764sgq50xxmckgqg3cnz3fcmvpqdjp7lclh313z";
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
