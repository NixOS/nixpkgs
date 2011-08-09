{ cabal, SHA, binary, pureMD5 }:

cabal.mkDerivation (self: {
  pname = "RSA";
  version = "1.0.6.1";
  sha256 = "1d0birzvapcsgay0wwh5v9mcd77sghj1bps9ws04ww9ga97gyp0l";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ SHA binary pureMD5 ];
  meta = {
    description = "Implementation of RSA, using the padding schemes of PKCS#1 v2.1.";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
