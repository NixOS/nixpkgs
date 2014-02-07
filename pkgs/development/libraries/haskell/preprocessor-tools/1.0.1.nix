{ cabal, mtl, parsec, syb }:

cabal.mkDerivation (self: {
  pname = "preprocessor-tools";
  version = "1.0.1";
  sha256 = "0ngfmvw6hvbr52i01n180ls4c8rx2wk2rka6g6igpvy9x2gwjin9";
  buildDepends = [ mtl parsec syb ];
  meta = {
    homepage = "http://www.eecs.harvard.edu/~tov/pubs/haskell-session-types/";
    description = "Extending Haskell's syntax using a custom preprocessor";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
