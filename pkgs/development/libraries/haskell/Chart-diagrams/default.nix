{ cabal, blazeSvg, Chart, colour, dataDefaultClass, diagramsCore
, diagramsLib, diagramsPostscript, diagramsSvg, lens, mtl
, operational, SVGFonts, text, time
}:

cabal.mkDerivation (self: {
  pname = "Chart-diagrams";
  version = "1.2";
  sha256 = "11pvyasra4mxid6826z6rkjhr71lg37fihzr8mgvjw3arascgqxz";
  buildDepends = [
    blazeSvg Chart colour dataDefaultClass diagramsCore diagramsLib
    diagramsPostscript diagramsSvg lens mtl operational SVGFonts text
    time
  ];
  meta = {
    homepage = "https://github.com/timbod7/haskell-chart/wiki";
    description = "Diagrams backend for Charts";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
