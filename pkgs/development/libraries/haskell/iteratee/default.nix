{ cabal, ListLike, MonadCatchIOTransformers, monadControl, parallel
, transformers, transformersBase
}:

cabal.mkDerivation (self: {
  pname = "iteratee";
  version = "0.8.9.1";
  sha256 = "1yk7jvabmabf0qjcd00imbg7vx84yjf71h7x3zbv4a51ykfy5hax";
  isLibrary = true;
  isExecutable = true;
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
