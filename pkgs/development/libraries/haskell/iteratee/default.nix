{ cabal, ListLike, MonadCatchIOTransformers, monadControl, parallel
, transformers, transformersBase
}:

cabal.mkDerivation (self: {
  pname = "iteratee";
  version = "0.8.9.3";
  sha256 = "1abm7f7ymzw9sa625f40sj4510sbpyplybpgb5a229sq8118dbh0";
  buildDepends = [
    ListLike MonadCatchIOTransformers monadControl parallel
    transformers transformersBase
  ];
  meta = {
    homepage = "http://www.tiresiaspress.us/haskell/iteratee";
    description = "Iteratee-based I/O";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
