{ cabal, attoparsec, blazeMarkup, blazeSvg, dataDefaultClass
, diagramsLib, parsec, split, text, tuple, vector, vectorSpace, xml
}:

cabal.mkDerivation (self: {
  pname = "SVGFonts";
  version = "1.4.0.1";
  sha256 = "0f878xg6qngl8ahk8zz03f1kyn2jq1dz05zw8av7s91x2ms8q3rg";
  buildDepends = [
    attoparsec blazeMarkup blazeSvg dataDefaultClass diagramsLib parsec
    split text tuple vector vectorSpace xml
  ];
  meta = {
    description = "Fonts from the SVG-Font format";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
