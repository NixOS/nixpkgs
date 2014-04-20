{ cabal, blazeSvg, Chart, colour, dataDefaultClass, diagramsCore
, diagramsLib, diagramsPostscript, diagramsSvg, lens, mtl
, operational, SVGFonts, text, time
}:

cabal.mkDerivation (self: {
  pname = "Chart-diagrams";
  version = "1.2.2";
  sha256 = "144dy9vp3x04s03jrkyfqczpwayb8k7dq702w9wm3d8q4ysva62q";
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
