{ cabal, mesa }:

cabal.mkDerivation (self: {
  pname = "OpenGLRaw";
  version = "1.1.0.1";
  sha256 = "0v6zcy4xvjj5g137rwjsh6hs0ni9dfkvsqynxv4bl5s78amppqnf";
  extraLibraries = [ mesa ];
  meta = {
    homepage = "http://www.haskell.org/HOpenGL/";
    description = "A raw binding for the OpenGL graphics system";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
