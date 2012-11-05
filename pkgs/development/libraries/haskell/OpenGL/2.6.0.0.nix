{ cabal, GLURaw, libX11, mesa, ObjectName, OpenGLRaw, StateVar
, Tensor
}:

cabal.mkDerivation (self: {
  pname = "OpenGL";
  version = "2.6.0.0";
  sha256 = "0rbdx73gcjx4ksqdjishlnn1ibxj21cqg5pxphy8bsphlygzc76l";
  buildDepends = [ GLURaw ObjectName OpenGLRaw StateVar Tensor ];
  extraLibraries = [ libX11 mesa ];
  noHaddock = true;
  meta = {
    homepage = "http://www.haskell.org/haskellwiki/Opengl";
    description = "A binding for the OpenGL graphics system";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
