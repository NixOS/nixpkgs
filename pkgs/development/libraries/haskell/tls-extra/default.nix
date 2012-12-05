{ cabal, certificate, cipherAes, cryptoApi, cryptocipher
, cryptohash, mtl, network, pem, text, time, tls, vector
}:

cabal.mkDerivation (self: {
  pname = "tls-extra";
  version = "0.5.1";
  sha256 = "0a977qy6ig4bhgsl6y5iw0xv52yswmcc2x37ypm1601wikjv38x3";
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
