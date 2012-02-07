{ cabal, mesa }:

cabal.mkDerivation (self: {
  pname = "OpenGLRaw";
  version = "1.2.0.0";
  sha256 = "1nwk93wlwh7gz2lb1dc88frmwik71g61a7k8xfiib2q5a8a8kf9r";
  extraLibraries = [ mesa ];
  meta = {
    homepage = "http://www.haskell.org/haskellwiki/Opengl";
    description = "A raw binding for the OpenGL graphics system";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
