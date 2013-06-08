{ cabal, transformers }:

cabal.mkDerivation (self: {
  pname = "monads-tf";
  version = "0.1.0.1";
  sha256 = "19za12iazwrbqwpxy6lkj01dwm921386ryxgdqvcqisn8cj6jm1v";
  buildDepends = [ transformers ];
  meta = {
    description = "Monad classes, using type families";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
