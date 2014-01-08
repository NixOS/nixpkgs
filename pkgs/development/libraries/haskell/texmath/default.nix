{ cabal, pandocTypes, parsec, syb, xml }:

cabal.mkDerivation (self: {
  pname = "texmath";
  version = "0.6.6";
  sha256 = "0mbimlvqsfx6w4dvilidy5cd9732kf6bnfnn6n7rnmq88avxxnmc";
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
