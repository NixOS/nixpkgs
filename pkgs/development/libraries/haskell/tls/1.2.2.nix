{ cabal, asn1Encoding, asn1Types, cereal, cipherAes, cipherRc4
, cprngAes, cryptohash, cryptoNumbers, cryptoPubkey
, cryptoPubkeyTypes, cryptoRandom, dataDefaultClass, mtl, network
, QuickCheck, testFramework, testFrameworkQuickcheck2, time, x509
, x509Store, x509Validation
}:

cabal.mkDerivation (self: {
  pname = "tls";
  version = "1.2.2";
  sha256 = "156l859mfpdax5rg1frwa5ms5bzggaja0mi795hh8i5c3ah7hfcp";
  buildDepends = [
    asn1Encoding asn1Types cereal cipherAes cipherRc4 cryptohash
    cryptoNumbers cryptoPubkey cryptoPubkeyTypes cryptoRandom
    dataDefaultClass mtl network x509 x509Store x509Validation
  ];
  testDepends = [
    cereal cprngAes cryptoPubkey cryptoRandom dataDefaultClass mtl
    QuickCheck testFramework testFrameworkQuickcheck2 time x509
    x509Validation
  ];
  doCheck = false;
  meta = {
    homepage = "http://github.com/vincenthz/hs-tls";
    description = "TLS/SSL protocol native implementation (Server and Client)";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
