{ cabal, hspec, liftedBase, monadControl, transformers
, transformersBase
}:

cabal.mkDerivation (self: {
  pname = "io-choice";
  version = "0.0.3";
  sha256 = "1dfl6n3r8hifl9rli2qvwgichz3h7nxq0v6m1k29vb8dv35ldsd8";
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
