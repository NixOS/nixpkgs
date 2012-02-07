{ cabal, parsec, syb, xml }:

cabal.mkDerivation (self: {
  pname = "texmath";
  version = "0.6.0.1";
  sha256 = "0q39a83g7kcj9qpnjg0v7pd0b4w9i090nl2s9v8lpv4n46z6cyaq";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ parsec syb xml ];
  meta = {
    homepage = "http://github.com/jgm/texmath";
    description = "Conversion of LaTeX math formulas to MathML or OMML";
    license = "GPL";
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
