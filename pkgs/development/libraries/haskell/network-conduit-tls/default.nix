{ cabal, aeson, certificate, conduit, connection, cprngAes
, cryptoApi, cryptoRandomApi, dataDefault, HUnit, monadControl, mtl
, network, networkConduit, pem, systemFileio, systemFilepath, tls
, transformers
}:

cabal.mkDerivation (self: {
  pname = "network-conduit-tls";
  version = "1.0.4.1";
  sha256 = "1l79v4ippyfw6pl4h3vqswh79vcif80phf6kq5fr4xmv3b6nbc06";
  buildDepends = [
    aeson certificate conduit connection cprngAes cryptoApi
    cryptoRandomApi dataDefault monadControl network networkConduit pem
    systemFileio systemFilepath tls transformers
  ];
  testDepends = [ conduit connection HUnit mtl networkConduit ];
  meta = {
    homepage = "https://github.com/snoyberg/conduit";
    description = "Create TLS-aware network code with conduits";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
