{ cabal, aeson, certificate, conduit, connection, cprngAes
, cryptoApi, cryptoRandomApi, dataDefault, monadControl, network
, networkConduit, pem, systemFileio, systemFilepath, tls, tlsExtra
, transformers
}:

cabal.mkDerivation (self: {
  pname = "network-conduit-tls";
  version = "1.0.2";
  sha256 = "0m3sbb4vpsjf568zaaxri8x7x46wngf5y2s5chgjzfmbj0amkl51";
  buildDepends = [
    aeson certificate conduit connection cprngAes cryptoApi
    cryptoRandomApi dataDefault monadControl network networkConduit pem
    systemFileio systemFilepath tls tlsExtra transformers
  ];
  meta = {
    homepage = "https://github.com/snoyberg/conduit";
    description = "Create TLS-aware network code with conduits";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
