{ cabal, ListLike, MonadCatchIOTransformers, parallel, transformers
}:

cabal.mkDerivation (self: {
  pname = "iteratee";
  version = "0.8.7.4";
  sha256 = "08smgb4xad8zpjzjrpjpv3vindhwgbcsf4rgipnrpyvz6mrg4w9i";
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
