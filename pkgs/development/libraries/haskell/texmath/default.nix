{ cabal, parsec, syb, xml }:

cabal.mkDerivation (self: {
  pname = "texmath";
  version = "0.6.0.2";
  sha256 = "04b642xbbgivbnpc8srqirdf71n5b6h5ir6rw0z2xpiv0znk6vh2";
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
