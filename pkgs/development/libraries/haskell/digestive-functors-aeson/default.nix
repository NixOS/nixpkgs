{ cabal, aeson, digestiveFunctors, HUnit, lens, mtl, safe
, scientific, tasty, tastyHunit, text, vector
}:

cabal.mkDerivation (self: {
  pname = "digestive-functors-aeson";
  version = "1.1.9";
  sha256 = "0lm6byv5vayzg2jp0fqkbi4wkbhvnjw5sl61qnvpa1pqk6p64mrm";
  buildDepends = [ aeson digestiveFunctors lens safe text vector ];
  testDepends = [
    aeson digestiveFunctors HUnit mtl scientific tasty tastyHunit text
  ];
  meta = {
    homepage = "http://github.com/ocharles/digestive-functors-aeson";
    description = "Run digestive-functors forms against JSON";
    license = self.stdenv.lib.licenses.gpl3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
