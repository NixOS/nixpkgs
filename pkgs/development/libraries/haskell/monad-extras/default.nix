{ cabal, mmorph, monadControl, stm, transformers, transformersBase
}:

cabal.mkDerivation (self: {
  pname = "monad-extras";
  version = "0.5.7";
  sha256 = "0dqj3n3ki679b6z5y7qw084chbahlqmj2vgj7yx0v552bl0ylzyj";
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
