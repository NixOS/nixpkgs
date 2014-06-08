{ cabal }:

cabal.mkDerivation (self: {
  pname = "bool-extras";
  version = "0.4.0";
  sha256 = "008m43f04ncx2c24c241gzwjyyglw8rwpq2gsakqkw0nwz3czs61";
  meta = {
    homepage = "http://tom.lokhorst.eu/bool-extras";
    description = "A fold function for Bool";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
