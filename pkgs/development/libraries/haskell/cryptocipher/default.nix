{ cabal, cipherAes, cipherBlowfish, cipherCamellia, cipherDes
, cipherRc4, cryptoCipherTypes
}:

cabal.mkDerivation (self: {
  pname = "cryptocipher";
  version = "0.6.0";
  sha256 = "1jgwn1j7h5rhg872ghmz54phxn7nlwmk83qv1cbnbww1l2ay8gz5";
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
