{ cabal, cairo, colour, dataDefaultClass, diagramsCore, diagramsLib
, filepath, lens, mtl, split, statestack, time
}:

cabal.mkDerivation (self: {
  pname = "diagrams-cairo";
  version = "1.0";
  sha256 = "1m549ryfyfjc6sg3xi0wlcpi4c0xj6yfrpjmxgiyl76rwaqns989";
  buildDepends = [
    cairo colour dataDefaultClass diagramsCore diagramsLib filepath
    lens mtl split statestack time
  ];
  meta = {
    homepage = "http://projects.haskell.org/diagrams";
    description = "Cairo backend for diagrams drawing EDSL";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
