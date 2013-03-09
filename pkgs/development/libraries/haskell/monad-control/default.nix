{ cabal, baseUnicodeSymbols, transformers, transformersBase }:

cabal.mkDerivation (self: {
  pname = "monad-control";
  version = "0.3.2";
  sha256 = "1gw1g89cjr993kcxjd1lvj94klrb8hsxn0yzyl1gmfk4273z39pa";
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
