{ cabal, certificate, cryptoApi, cryptocipher, cryptohash, mtl
, network, pem, text, time, tls, vector
}:

cabal.mkDerivation (self: {
  pname = "tls-extra";
  version = "0.4.7";
  sha256 = "1ykmwkzq2vwjvcvg8c9b020baqxp3w7w0x7ka7jrk88aqmil9hiq";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    certificate cryptoApi cryptocipher cryptohash mtl network pem text
    time tls vector
  ];
  meta = {
    homepage = "http://github.com/vincenthz/hs-tls-extra";
    description = "TLS extra default values and helpers";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
