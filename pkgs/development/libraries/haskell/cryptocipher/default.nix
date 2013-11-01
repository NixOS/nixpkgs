{ cabal, cipherAes, cipherBlowfish, cipherCamellia, cipherDes
, cipherRc4, cryptoCipherTypes
}:

cabal.mkDerivation (self: {
  pname = "cryptocipher";
  version = "0.6.2";
  sha256 = "0ip3a2as0df6drl29sryayxx22sx55v6bs60s2fh3i1nxqnydf9l";
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
