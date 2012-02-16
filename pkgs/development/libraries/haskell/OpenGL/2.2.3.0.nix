{ cabal, Cabal, libX11, mesa }:

cabal.mkDerivation (self: {
  pname = "OpenGL";
  version = "2.2.3.0";
  sha256 = "00h5zdm64mfj5fwnd52kyn9aynsbzqwfic0ymjjakz90pdvk4p57";
  buildDepends = [ Cabal ];
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
