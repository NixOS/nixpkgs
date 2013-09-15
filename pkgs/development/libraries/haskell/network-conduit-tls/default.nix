{ cabal, aeson, certificate, conduit, cprngAes, cryptoApi
, cryptoRandomApi, network, networkConduit, pem, systemFileio
, systemFilepath, tls, tlsExtra, transformers
}:

cabal.mkDerivation (self: {
  pname = "network-conduit-tls";
  version = "1.0.1.1";
  sha256 = "0v5rspcjhd2vid5i74dy1sdcvci7dlr88sgr0v9vjp4gcyb29qlj";
  buildDepends = [
    aeson certificate conduit cprngAes cryptoApi cryptoRandomApi
    network networkConduit pem systemFileio systemFilepath tls tlsExtra
    transformers
  ];
  meta = {
    homepage = "https://github.com/snoyberg/conduit";
    description = "Create TLS-aware network code with conduits";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
