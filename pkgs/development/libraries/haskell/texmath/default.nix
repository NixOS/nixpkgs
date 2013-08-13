{ cabal, parsec, syb, xml }:

cabal.mkDerivation (self: {
  pname = "texmath";
  version = "0.6.3";
  sha256 = "1ajza3p4rj318l03rffscqs6rbk635drmdciv7hhl4nljc4qmnpz";
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
