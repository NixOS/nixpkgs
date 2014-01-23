{ cabal, aeson, certificate, conduit, connection, cprngAes
, cryptoApi, cryptoRandomApi, dataDefault, HUnit, monadControl, mtl
, network, networkConduit, pem, systemFileio, systemFilepath, tls
, tlsExtra, transformers
}:

cabal.mkDerivation (self: {
  pname = "network-conduit-tls";
  version = "1.0.3";
  sha256 = "0l8h9pfrrqzkf45cp5r8kxpzc2fi6m01s4zkrh0d226rbps3gmvc";
  buildDepends = [
    aeson certificate conduit connection cprngAes cryptoApi
    cryptoRandomApi dataDefault monadControl network networkConduit pem
    systemFileio systemFilepath tls tlsExtra transformers
  ];
  testDepends = [ conduit connection HUnit mtl networkConduit ];
  meta = {
    homepage = "https://github.com/snoyberg/conduit";
    description = "Create TLS-aware network code with conduits";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
