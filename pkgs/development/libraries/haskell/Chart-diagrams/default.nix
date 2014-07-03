{ cabal, blazeSvg, Chart, colour, dataDefaultClass, diagramsCore
, diagramsLib, diagramsPostscript, diagramsSvg, lens, mtl
, operational, SVGFonts, text, time
}:

cabal.mkDerivation (self: {
  pname = "Chart-diagrams";
  version = "1.2.3";
  sha256 = "08ps30vn9ljiyhgakwdbixn4csy504bsw3h5z9w1dxhn27wij772";
  buildDepends = [
    blazeSvg Chart colour dataDefaultClass diagramsCore diagramsLib
    diagramsPostscript diagramsSvg lens mtl operational SVGFonts text
    time
  ];
  jailbreak = true;
  meta = {
    homepage = "https://github.com/timbod7/haskell-chart/wiki";
    description = "Diagrams backend for Charts";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
