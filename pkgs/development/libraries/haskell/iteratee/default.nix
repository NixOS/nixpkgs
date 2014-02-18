{ cabal, ListLike, MonadCatchIOTransformers, monadControl, parallel
, transformers, transformersBase
}:

cabal.mkDerivation (self: {
  pname = "iteratee";
  version = "0.8.9.5";
  sha256 = "0akv7zcyb3c213f8qz1xv1qyq04wa427a4mh8rmz1jlmcwiznk7z";
  buildDepends = [
    ListLike MonadCatchIOTransformers monadControl parallel
    transformers transformersBase
  ];
  jailbreak = true;
  meta = {
    homepage = "http://www.tiresiaspress.us/haskell/iteratee";
    description = "Iteratee-based I/O";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
