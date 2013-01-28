{ cabal, semigroupoids, semigroups }:

cabal.mkDerivation (self: {
  pname = "bifunctors";
  version = "3.0.3";
  sha256 = "1nmrwc9n9qkj9w9c38ja0had32isr6v35j1v19fhqdwk5ddbpxp4";
  buildDepends = [ semigroupoids semigroups ];
  meta = {
    homepage = "http://github.com/ekmett/bifunctors/";
    description = "Haskell 98 bifunctors";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
