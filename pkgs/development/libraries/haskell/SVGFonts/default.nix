{ cabal, attoparsec, blazeMarkup, blazeSvg, dataDefaultClass
, diagramsLib, parsec, split, text, tuple, vector, vectorSpace, xml
}:

cabal.mkDerivation (self: {
  pname = "SVGFonts";
  version = "1.4.0.2";
  sha256 = "1a1f0jdz36zpj1196zv5qwg35rm4ra0b4z5spr1m3696292nj8ph";
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
