{ cabal, baseUnicodeSymbols, transformers, transformersBase }:

cabal.mkDerivation (self: {
  pname = "monad-control";
  version = "0.3.1.2";
  sha256 = "0nrvz5zc5w7j2payg7ji7dpvkbk4ssg75pwi3pqjq6jrfyf4aw9m";
  buildDepends = [
    baseUnicodeSymbols transformers transformersBase
  ];
  meta = {
    homepage = "https://github.com/basvandijk/monad-control";
    description = "Lift control operations, like exception catching, through monad transformers";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
