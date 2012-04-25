{ cabal, binary, cryptoApi, cryptoPubkeyTypes, monadcryptorandom
, pureMD5, SHA
}:

cabal.mkDerivation (self: {
  pname = "RSA";
  version = "1.2.1.0";
  sha256 = "14x53xjy4rqdgin6kyrm2b16hb0k599gfiwiwrsyri9mx3f3s1ca";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    binary cryptoApi cryptoPubkeyTypes monadcryptorandom pureMD5 SHA
  ];
  meta = {
    description = "Implementation of RSA, using the padding schemes of PKCS#1 v2.1.";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
