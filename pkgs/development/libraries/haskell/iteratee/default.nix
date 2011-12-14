{ cabal, ListLike, MonadCatchIOTransformers, parallel, transformers
}:

cabal.mkDerivation (self: {
  pname = "iteratee";
  version = "0.8.7.5";
  sha256 = "182bxdnj7k4dkmrbnkzy93axq8hwpq3xdbkyf93hbzzp4vhdvjnl";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    ListLike MonadCatchIOTransformers parallel transformers
  ];
  meta = {
    homepage = "http://www.tiresiaspress.us/haskell/iteratee";
    description = "Iteratee-based I/O";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
