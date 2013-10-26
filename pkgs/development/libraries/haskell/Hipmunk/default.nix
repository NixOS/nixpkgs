{ cabal, StateVar, transformers }:

cabal.mkDerivation (self: {
  pname = "Hipmunk";
  version = "5.2.0.12";
  sha256 = "0gybmwwij6gs3gsklcvck0nc1niyh6pvirnxgrcwclrz94ivpj42";
  buildDepends = [ StateVar transformers ];
  meta = {
    homepage = "https://github.com/meteficha/Hipmunk";
    description = "A Haskell binding for Chipmunk";
    license = "unknown";
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
