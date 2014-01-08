{ cabal, binary, cryptoApi, cryptoPubkeyTypes, DRBG
, monadcryptorandom, pureMD5, QuickCheck, SHA, tagged
, testFramework, testFrameworkQuickcheck2
}:

cabal.mkDerivation (self: {
  pname = "RSA";
  version = "2.0";
  sha256 = "170bjcqd6q8q0c0idjpm9vgn02ifwxz1xvwp1l30qdf56293p4bq";
  buildDepends = [
    binary cryptoApi cryptoPubkeyTypes monadcryptorandom pureMD5 SHA
  ];
  testDepends = [
    binary cryptoApi cryptoPubkeyTypes DRBG pureMD5 QuickCheck SHA
    tagged testFramework testFrameworkQuickcheck2
  ];
  doCheck = false;
  meta = {
    description = "Implementation of RSA, using the padding schemes of PKCS#1 v2.1.";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
