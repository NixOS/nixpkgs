{ cabal, parsec, syb, xml }:

cabal.mkDerivation (self: {
  pname = "texmath";
  version = "0.6.1.3";
  sha256 = "1f2hka9jwlrm9dvw7z3896yfpdzxs2vaw0vbcmj5p401mvzc8w05";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ parsec syb xml ];
  meta = {
    homepage = "http://github.com/jgm/texmath";
    description = "Conversion of LaTeX math formulas to MathML or OMML";
    license = "GPL";
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
