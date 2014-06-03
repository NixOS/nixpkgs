{ cabal, pandocTypes, parsec, syb, xml }:

cabal.mkDerivation (self: {
  pname = "texmath";
  version = "0.6.6.2";
  sha256 = "0lwkbniw7nn19gaw5bl1fsbl5q54n111zpiwz8b49d03vmmvd3hs";
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
