{ cabal, certificate, cipherAes, cryptoApi, cryptocipher
, cryptohash, mtl, network, pem, text, time, tls, vector
}:

cabal.mkDerivation (self: {
  pname = "tls-extra";
  version = "0.5.0";
  sha256 = "1r645qljn3ql7jcphsqf4cm259cl8fsva64q4p2x37mafi01bkr8";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    certificate cipherAes cryptoApi cryptocipher cryptohash mtl network
    pem text time tls vector
  ];
  meta = {
    homepage = "http://github.com/vincenthz/hs-tls";
    description = "TLS extra default values and helpers";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
