{ cabal, MonadRandom, mtl, semigroupoids, semigroups, transformers
}:

cabal.mkDerivation (self: {
  pname = "either";
  version = "3.1";
  sha256 = "1paglfhd2xjr32sh5npl3kvamv4nps9fpy0wk9ya0l26w4c3bdsm";
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
