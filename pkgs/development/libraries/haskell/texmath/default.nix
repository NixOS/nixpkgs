{ cabal, pandocTypes, parsec, syb, xml }:

cabal.mkDerivation (self: {
  pname = "texmath";
  version = "0.6.4";
  sha256 = "090xqs14ap3c6pljqzyva46phxb1lhqayi4g098f6d77d1ygvshf";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ pandocTypes parsec syb xml ];
  meta = {
    homepage = "http://github.com/jgm/texmath";
    description = "Conversion of LaTeX math formulas to MathML or OMML";
    license = "GPL";
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
