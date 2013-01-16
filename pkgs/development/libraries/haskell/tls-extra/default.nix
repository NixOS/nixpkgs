{ cabal, certificate, cipherAes, cipherRc4, cryptohash
, cryptoPubkey, cryptoRandomApi, mtl, network, pem, text, time, tls
, vector
}:

cabal.mkDerivation (self: {
  pname = "tls-extra";
  version = "0.6.0";
  sha256 = "11cf91cgbyp4xzbr3n9h20rvbb6756r9dk74r5w158f3xmlgk5nx";
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
