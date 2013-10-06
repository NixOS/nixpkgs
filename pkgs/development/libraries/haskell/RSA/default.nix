{ cabal, binary, cryptoApi, cryptoPubkeyTypes, monadcryptorandom
, pureMD5, SHA
}:

cabal.mkDerivation (self: {
  pname = "RSA";
  version = "1.2.2.0";
  sha256 = "0x4an1060slppyccf18isqrdl548ll33xzzqch3qxg285a0mm12m";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    binary cryptoApi cryptoPubkeyTypes monadcryptorandom pureMD5 SHA
  ];
  meta = {
    description = "Implementation of RSA, using the padding schemes of PKCS#1 v2.1";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
