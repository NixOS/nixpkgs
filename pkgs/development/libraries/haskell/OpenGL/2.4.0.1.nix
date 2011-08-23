{ cabal, GLURaw, libX11, mesa, ObjectName, OpenGLRaw, StateVar
, Tensor
}:

cabal.mkDerivation (self: {
  pname = "OpenGL";
  version = "2.4.0.1";
  sha256 = "0xdclf0m7qxp4157053cbsybpy7fqiiiak0g2kyf8awr7a5736n5";
  buildDepends = [ GLURaw ObjectName OpenGLRaw StateVar Tensor ];
  extraLibraries = [ libX11 mesa ];
  meta = {
    homepage = "http://www.haskell.org/HOpenGL/";
    description = "A binding for the OpenGL graphics system";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
