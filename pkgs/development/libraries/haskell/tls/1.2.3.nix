{ cabal, asn1Encoding, asn1Types, byteable, cereal, cipherAes
, cipherRc4, cprngAes, cryptohash, cryptoNumbers, cryptoPubkey
, cryptoPubkeyTypes, cryptoRandom, dataDefaultClass, mtl, network
, QuickCheck, testFramework, testFrameworkQuickcheck2, time, x509
, x509Store, x509Validation
}:

cabal.mkDerivation (self: {
  pname = "tls";
  version = "1.2.3";
  sha256 = "0vv81z5m223b90zzfp5dk376fh8yngyd8h9anrxjrqb4f3bycaxg";
  buildDepends = [
    asn1Encoding asn1Types byteable cereal cipherAes cipherRc4
    cryptohash cryptoNumbers cryptoPubkey cryptoPubkeyTypes
    cryptoRandom dataDefaultClass mtl network x509 x509Store
    x509Validation
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
