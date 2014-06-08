{ cabal, mmorph, monadControl, stm, transformers, transformersBase
}:

cabal.mkDerivation (self: {
  pname = "monad-extras";
  version = "0.5.8";
  sha256 = "1h7gjdmbdjw2k49xlflca88bxiid7gxl8l9gzmywybllff376npl";
  buildDepends = [
    mmorph monadControl stm transformers transformersBase
  ];
  meta = {
    homepage = "http://github.com/jwiegley/monad-extras";
    description = "Extra utility functions for working with monads";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
