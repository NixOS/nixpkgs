{ cabal, aeson, certificate, conduit, cryptoApi, cryptoRandomApi
, network, networkConduit, pem, systemFileio, systemFilepath, tls
, tlsExtra, transformers
}:

cabal.mkDerivation (self: {
  pname = "network-conduit-tls";
  version = "1.0.0.3";
  sha256 = "0gaws4spd50dmqjsxdxvjk5n5l0ib4q0brwnxrk725d3b3hanpz1";
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
