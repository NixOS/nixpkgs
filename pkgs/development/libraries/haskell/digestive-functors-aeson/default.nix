{ cabal, aeson, digestiveFunctors, HUnit, lens, mtl, safe, tasty
, tastyHunit, text, vector
}:

cabal.mkDerivation (self: {
  pname = "digestive-functors-aeson";
  version = "1.1.5";
  sha256 = "1mxi8zbv3hxy2crj6h6p1a885k8rd0fqhmwq7l7w7d7d73h8bmm3";
  buildDepends = [ aeson digestiveFunctors lens safe text vector ];
  testDepends = [
    aeson digestiveFunctors HUnit mtl tasty tastyHunit text
  ];
  meta = {
    homepage = "http://github.com/ocharles/digestive-functors-aeson";
    description = "Run digestive-functors forms against JSON";
    license = self.stdenv.lib.licenses.gpl3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
