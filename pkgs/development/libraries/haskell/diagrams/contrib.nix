{ cabal, colour, dataDefault, diagramsLib, forceLayout, lens, mtl
, vectorSpace
}:

cabal.mkDerivation (self: {
  pname = "diagrams-contrib";
  version = "0.6.0.1";
  sha256 = "1wrfdsfb2yj93wq2ykxjyg6g0q56bmxd2rc6r3gd0zcs8kiimaar";
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
