{ cabal, colour, dataDefault, diagramsLib, forceLayout, lens, mtl
, vectorSpace
}:

cabal.mkDerivation (self: {
  pname = "diagrams-contrib";
  version = "0.6.0.2";
  sha256 = "1lj99a46r12zjwmpkn7vj04wapfgdlmw05jwb5lnhy9hxqgcsgng";
  buildDepends = [
    colour dataDefault diagramsLib forceLayout lens mtl vectorSpace
  ];
  meta = {
    homepage = "http://projects.haskell.org/diagrams/";
    description = "Collection of user contributions to diagrams EDSL";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
