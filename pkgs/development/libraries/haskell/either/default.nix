{ cabal, MonadRandom, mtl, semigroupoids, semigroups, transformers
}:

cabal.mkDerivation (self: {
  pname = "either";
  version = "3.4.2";
  sha256 = "0h5hrjvcbgyn0fpn6xlm2a4447xl4qyhiadq2vlywqvkvgnh3x3k";
  buildDepends = [
    MonadRandom mtl semigroupoids semigroups transformers
  ];
  meta = {
    homepage = "http://github.com/ekmett/either/";
    description = "An either monad transformer";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
