{ cabal, certificate, cipherAes, cipherRc4, cryptohash
, cryptoPubkey, cryptoRandom, mtl, network, pem, time, tls, vector
}:

cabal.mkDerivation (self: {
  pname = "tls-extra";
  version = "0.6.5";
  sha256 = "09b8wxg4k88gdzpbxhd2apf0x5y51zh2zbw2cvraffjnnfkgvzqc";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    certificate cipherAes cipherRc4 cryptohash cryptoPubkey
    cryptoRandom mtl network pem time tls vector
  ];
  jailbreak = true;
  meta = {
    homepage = "http://github.com/vincenthz/hs-tls";
    description = "TLS extra default values and helpers";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
