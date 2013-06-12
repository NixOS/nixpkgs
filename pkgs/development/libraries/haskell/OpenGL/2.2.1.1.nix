{ cabal, libX11, mesa }:

cabal.mkDerivation (self: {
  pname = "OpenGL";
  version = "2.2.1.1";
  sha256 = "926ca25cf9502cdaaeb8ade484015468cb60594e1bfbf0e04bd01235d8d9a792";
  extraLibraries = [ libX11 mesa ];
  meta = {
    homepage = "http://www.haskell.org/HOpenGL/";
    description = "A binding for the OpenGL graphics system";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
