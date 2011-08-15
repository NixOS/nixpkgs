{cabal, mesa, libX11}:

cabal.mkDerivation (self: {
  pname = "OpenGL";
  version = "2.2.1.1"; # Haskell Platform 2009.0.0
  sha256 = "926ca25cf9502cdaaeb8ade484015468cb60594e1bfbf0e04bd01235d8d9a792";
  propagatedBuildInputs = [mesa libX11];
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
