{ cabal, aeson, digestiveFunctors, HUnit, lens, lensAeson, mtl
, safe, tasty, tastyHunit, text, vector
}:

cabal.mkDerivation (self: {
  pname = "digestive-functors-aeson";
  version = "1.1.4";
  sha256 = "1rca25zycmz4al5izq8j7h3cggvb4844g3gj3a1686yy38k5rfvn";
  buildDepends = [
    aeson digestiveFunctors lens lensAeson safe text vector
  ];
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
