{ cabal, aeson, aesonLens, digestiveFunctors, HUnit, lens, mtl
, safe, tasty, tastyHunit, text, vector
}:

cabal.mkDerivation (self: {
  pname = "digestive-functors-aeson";
  version = "1.1.3";
  sha256 = "0194yd2b9irm1gmk3d8awrsrmsr4lml63wr4vm8a92s7w3hdy0db";
  buildDepends = [
    aeson aesonLens digestiveFunctors lens safe text vector
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
