{ cabal, hspec, liftedBase, monadControl, transformers
, transformersBase
}:

cabal.mkDerivation (self: {
  pname = "io-choice";
  version = "0.0.2";
  sha256 = "0kxn357cc31gvaajg41h6xwpivq049dl1zd551xfvrvzndvy061f";
  buildDepends = [
    liftedBase monadControl transformers transformersBase
  ];
  testDepends = [ hspec liftedBase monadControl transformers ];
  meta = {
    description = "Choice for IO and lifted IO";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
