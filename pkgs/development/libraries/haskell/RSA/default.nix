{ cabal, binary, pureMD5, random, SHA }:

cabal.mkDerivation (self: {
  pname = "RSA";
  version = "1.0.6.2";
  sha256 = "0sabvwzgjg6nv5m3x9cjpk5q62r8vhi3kn858ask15frsi7lzhwk";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ binary pureMD5 random SHA ];
  meta = {
    description = "Implementation of RSA, using the padding schemes of PKCS#1 v2.1.";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
