{ cabal, ListLike, MonadCatchIOTransformers, monadControl, parallel
, transformers, transformersBase
}:

cabal.mkDerivation (self: {
  pname = "iteratee";
  version = "0.8.9.4";
  sha256 = "0j8q5i3kf1ld7630z65hj55p2jlhl23f6qjag4zwrhrh38bfr531";
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
