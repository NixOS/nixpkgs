{ cabal, MonadRandom, mtl, semigroupoids, semigroups, transformers
}:

cabal.mkDerivation (self: {
  pname = "either";
  version = "3.4";
  sha256 = "05nbp8gp50wq592k6dsrpzp6wmqjn9pz6mkizqfb65z1wvd1xiz2";
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
