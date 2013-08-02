{ cabal, MonadRandom, mtl, semigroupoids, semigroups, transformers
}:

cabal.mkDerivation (self: {
  pname = "either";
  version = "3.4.1";
  sha256 = "1cq4glqhxz9k8fxf0dc8b6hcxxfn4yci6h7wmfkmkfq5ca61ax1b";
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
