{ cabal, cairo, cmdargs, diagramsCore, diagramsLib, filepath, gtk
, mtl, split
}:

cabal.mkDerivation (self: {
  pname = "diagrams-cairo";
  version = "0.5.0.2";
  sha256 = "1wwk65c2cx7rkhmai5spms791fjhl3snwhj0w9399q8pgj6g4lj8";
  buildDepends = [
    cairo cmdargs diagramsCore diagramsLib filepath gtk mtl split
  ];
  jailbreak = true;
  meta = {
    homepage = "http://projects.haskell.org/diagrams";
    description = "Cairo backend for diagrams drawing EDSL";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
