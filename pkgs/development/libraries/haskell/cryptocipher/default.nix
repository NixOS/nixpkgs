{ cabal, cereal, cipherAes, cipherRc4, cpu, cryptoApi, cryptohash
, entropy, primitive, QuickCheck, testFramework
, testFrameworkQuickcheck2, vector
}:

cabal.mkDerivation (self: {
  pname = "cryptocipher";
  version = "0.5.2";
  sha256 = "0ffd3w2hvi1zbhgk0xvgbnlfzzwijbrs5b9b4g2vc5p69wkv24zr";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    cereal cipherAes cipherRc4 cpu cryptoApi primitive vector
  ];
  testDepends = [
    cryptoApi cryptohash entropy QuickCheck testFramework
    testFrameworkQuickcheck2 vector
  ];
  meta = {
    homepage = "http://github.com/vincenthz/hs-crypto-cipher";
    description = "Symmetrical block and stream ciphers";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
