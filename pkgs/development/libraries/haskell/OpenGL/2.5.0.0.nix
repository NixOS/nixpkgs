{ cabal, GLURaw, libX11, mesa, ObjectName, OpenGLRaw, StateVar
, Tensor
}:

cabal.mkDerivation (self: {
  pname = "OpenGL";
  version = "2.5.0.0";
  sha256 = "1kpakn5i4aka67mqcpfq9jpl38h409x63zd14y35abpm6h3x8m3j";
  buildDepends = [ GLURaw ObjectName OpenGLRaw StateVar Tensor ];
  extraLibraries = [ libX11 mesa ];
  meta = {
    homepage = "http://www.haskell.org/haskellwiki/Opengl";
    description = "A binding for the OpenGL graphics system";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
