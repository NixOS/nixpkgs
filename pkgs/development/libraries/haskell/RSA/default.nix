{ cabal, binary, pureMD5, random, SHA }:

cabal.mkDerivation (self: {
  pname = "RSA";
  version = "1.0.6.3";
  sha256 = "0lk3nsh6nvacv1xzrg2pxxhd5gglmy40dkb8a47c9r9px0q6yjpj";
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
