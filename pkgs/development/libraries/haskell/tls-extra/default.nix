{ cabal, certificate, cryptoApi, cryptocipher, cryptohash, mtl
, network, text, time, tls, vector
}:

cabal.mkDerivation (self: {
  pname = "tls-extra";
  version = "0.4.3";
  sha256 = "1qr7l70c5fgqpf9hnhsngghcss2cannhca1snlvbcrq074hc2f2n";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    certificate cryptoApi cryptocipher cryptohash mtl network text time
    tls vector
  ];
  meta = {
    homepage = "http://github.com/vincenthz/hs-tls-extra";
    description = "TLS extra default values and helpers";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
