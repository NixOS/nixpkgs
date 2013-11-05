{ cabal, pandocTypes, parsec, syb, xml }:

cabal.mkDerivation (self: {
  pname = "texmath";
  version = "0.6.5.1";
  sha256 = "022gpxamc31p9gsk9bxf04qyvcdbdiwj617l5z04q21lj0758wzk";
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
