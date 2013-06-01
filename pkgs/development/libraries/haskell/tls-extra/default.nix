{ cabal, certificate, cipherAes, cipherRc4, cryptohash
, cryptoPubkey, cryptoRandomApi, mtl, network, pem, text, time, tls
, vector
}:

cabal.mkDerivation (self: {
  pname = "tls-extra";
  version = "0.6.3";
  sha256 = "1ng8h3v5px63fpb4y3sd47djzpksyzzavilsdnp1kd453abpmx9l";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    certificate cipherAes cipherRc4 cryptohash cryptoPubkey
    cryptoRandomApi mtl network pem text time tls vector
  ];
  meta = {
    homepage = "http://github.com/vincenthz/hs-tls";
    description = "TLS extra default values and helpers";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
