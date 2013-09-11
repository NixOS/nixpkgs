{ cabal, cipherAes, cipherBlowfish, cipherCamellia, cipherDes
, cipherRc4, cryptoCipherTypes
}:

cabal.mkDerivation (self: {
  pname = "cryptocipher";
  version = "0.6.1";
  sha256 = "1qa0s7mr1a3nv4ppyk8wr57rxbfc2qpw9rq26pfziwnpin5k2j3x";
  buildDepends = [
    cipherAes cipherBlowfish cipherCamellia cipherDes cipherRc4
    cryptoCipherTypes
  ];
  meta = {
    homepage = "http://github.com/vincenthz/hs-crypto-cipher";
    description = "Symmetrical block and stream ciphers";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
