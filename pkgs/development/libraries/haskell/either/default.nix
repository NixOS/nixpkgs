{ cabal, MonadRandom, mtl, semigroupoids, semigroups, transformers
}:

cabal.mkDerivation (self: {
  pname = "either";
  version = "4.0";
  sha256 = "07axaq43cqyglndr5az7ns4mvkjmybq6z8s32l1jxc5x7532scwr";
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
