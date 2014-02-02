{ cabal, cairo, colour, dataDefaultClass, diagramsCore, diagramsLib
, filepath, hashable, lens, mtl, split, statestack, time
}:

cabal.mkDerivation (self: {
  pname = "diagrams-cairo";
  version = "1.0.1.1";
  sha256 = "0mjc24sir0mm1kqhkk26mfbz90kc71hdylral4bjymxs6fpx7crh";
  buildDepends = [
    cairo colour dataDefaultClass diagramsCore diagramsLib filepath
    hashable lens mtl split statestack time
  ];
  meta = {
    homepage = "http://projects.haskell.org/diagrams";
    description = "Cairo backend for diagrams drawing EDSL";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
