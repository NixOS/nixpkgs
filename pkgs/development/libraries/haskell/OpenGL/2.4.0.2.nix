{ cabal, Cabal, GLURaw, libX11, mesa, ObjectName, OpenGLRaw
, StateVar, Tensor
}:

cabal.mkDerivation (self: {
  pname = "OpenGL";
  version = "2.4.0.2";
  sha256 = "00rjvm02p6h8vbyxi3ri4jkk75ki414wk5al2z2fsszjfpdl93b6";
  buildDepends = [
    Cabal GLURaw ObjectName OpenGLRaw StateVar Tensor
  ];
  extraLibraries = [ libX11 mesa ];
  meta = {
    homepage = "http://www.haskell.org/haskellwiki/Opengl";
    description = "A binding for the OpenGL graphics system";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
