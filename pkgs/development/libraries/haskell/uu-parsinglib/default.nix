{ cabal, ListLike, time }:

cabal.mkDerivation (self: {
  pname = "uu-parsinglib";
  version = "2.7.3";
  sha256 = "18387pq6mqg6mns1cd16d22h98mx1xnz584q8w3rmn4cndrk3883";
  buildDepends = [ ListLike time ];
  meta = {
    homepage = "http://www.cs.uu.nl/wiki/bin/view/HUT/ParserCombinators";
    description = "Fast, online, error-correcting, monadic, applicative, merging, permuting, idiomatic parser combinators";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
