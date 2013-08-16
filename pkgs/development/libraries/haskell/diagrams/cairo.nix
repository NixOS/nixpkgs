{ cabal, cairo, cmdargs, colour, diagramsCore, diagramsLib
, filepath, mtl, split, time
}:

cabal.mkDerivation (self: {
  pname = "diagrams-cairo";
  version = "0.7";
  sha256 = "14ghcrzzpqdnvmpvykhf4r74sb9jgp69094mkwydslzmi8dsgdiy";
  buildDepends = [
    cairo cmdargs colour diagramsCore diagramsLib filepath mtl split
    time
  ];
  meta = {
    homepage = "http://projects.haskell.org/diagrams";
    description = "Cairo backend for diagrams drawing EDSL";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
