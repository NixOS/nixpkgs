{ cabal, aeson, certificate, conduit, cryptoApi, cryptoRandomApi
, network, networkConduit, pem, systemFileio, systemFilepath, tls
, tlsExtra, transformers
}:

cabal.mkDerivation (self: {
  pname = "network-conduit-tls";
  version = "1.0.0.2";
  sha256 = "1vzhalz6hxal73rxm6f2l9m7j34mldamz16wrb6ay67wg6giq55z";
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
