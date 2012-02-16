{ cabal, parsec, syb, xml }:

cabal.mkDerivation (self: {
  pname = "texmath";
  version = "0.6.0.3";
  sha256 = "0vj1kh62qs7badv00lcda9m3j53kc069kmrv5lmz62a96y4kx5yi";
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
