{ cabal, binary, cryptoApi, cryptoPubkeyTypes, DRBG
, monadcryptorandom, pureMD5, QuickCheck, SHA, tagged
, testFramework, testFrameworkQuickcheck2
}:

cabal.mkDerivation (self: {
  pname = "RSA";
  version = "2.0.0";
  sha256 = "1v2d6sxpqr0lmiqdr3ym5qzp3p1y57yj6939vdlsac6k6ifj6pwq";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    binary cryptoApi cryptoPubkeyTypes DRBG monadcryptorandom pureMD5
    QuickCheck SHA tagged testFramework testFrameworkQuickcheck2
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
