{ cabal, aeson, digestiveFunctors, HUnit, lens, mtl, safe
, scientific, tasty, tastyHunit, text, vector
}:

cabal.mkDerivation (self: {
  pname = "digestive-functors-aeson";
  version = "1.1.8";
  sha256 = "0qvzr9s0vzgzh7mix6ncjn731krln9w47zrqb5jkj92rv7mf5sgz";
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
