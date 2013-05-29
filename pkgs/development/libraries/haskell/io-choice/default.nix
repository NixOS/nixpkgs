{ cabal, hspec, liftedBase, monadControl, transformers
, transformersBase
}:

cabal.mkDerivation (self: {
  pname = "io-choice";
  version = "0.0.4";
  sha256 = "1b6jvk37jkpd4m3r6ip70xwzrz67a30yam831nqpljsbgk2f9arq";
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
