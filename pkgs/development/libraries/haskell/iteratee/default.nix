{ cabal, ListLike, MonadCatchIOTransformers, parallel, transformers
}:

cabal.mkDerivation (self: {
  pname = "iteratee";
  version = "0.8.8.2";
  sha256 = "1d76an95y8svaja5ksx8p05fk22z62hp3gfwnd1d917qccffw6ry";
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
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
