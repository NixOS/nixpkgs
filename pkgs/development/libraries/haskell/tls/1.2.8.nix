{ cabal, asn1Encoding, asn1Types, byteable, cereal, cipherAes
, cipherDes, cipherRc4, cprngAes, cryptoCipherTypes, cryptohash
, cryptoNumbers, cryptoPubkey, cryptoPubkeyTypes, cryptoRandom
, dataDefaultClass, mtl, network, QuickCheck, testFramework
, testFrameworkQuickcheck2, time, x509, x509Store, x509Validation
}:

cabal.mkDerivation (self: {
  pname = "tls";
  version = "1.2.8";
  sha256 = "0fm36jn2yri3fn6wadl5v4k0cpnansqlid4fhavgnp6mazf0q5ha";
  buildDepends = [
    asn1Encoding asn1Types byteable cereal cipherAes cipherDes
    cipherRc4 cryptoCipherTypes cryptohash cryptoNumbers cryptoPubkey
    cryptoPubkeyTypes cryptoRandom dataDefaultClass mtl network x509
    x509Store x509Validation
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
