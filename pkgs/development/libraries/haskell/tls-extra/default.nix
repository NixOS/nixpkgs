{ cabal, certificate, cipherAes, cipherRc4, cryptohash
, cryptoPubkey, cryptoRandomApi, mtl, network, pem, text, time, tls
, vector
}:

cabal.mkDerivation (self: {
  pname = "tls-extra";
  version = "0.6.4";
  sha256 = "058ia1cabs7ribz287iqkkjvqpp2n7c219f3xc92fhm0qq00mh5n";
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
