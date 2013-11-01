{ cabal, blazeSvg, cmdargs, colour, diagramsCore, diagramsLib
, filepath, monoidExtras, mtl, split, time, vectorSpace
}:

cabal.mkDerivation (self: {
  pname = "diagrams-svg";
  version = "0.8.0.2";
  sha256 = "0ahapj040qy74kcj9f786ddd28xysq1wch087wsh8sdfp57z5dbz";
  buildDepends = [
    blazeSvg cmdargs colour diagramsCore diagramsLib filepath
    monoidExtras mtl split time vectorSpace
  ];
  meta = {
    homepage = "http://projects.haskell.org/diagrams/";
    description = "SVG backend for diagrams drawing EDSL";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
