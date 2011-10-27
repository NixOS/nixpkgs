{ cabal, ListLike, time }:

cabal.mkDerivation (self: {
  pname = "uu-parsinglib";
  version = "2.7.2.1";
  sha256 = "1dablvx1mrgwzm6fqsbgny3qf9bz3bilhip1b78b5gxrbssfpdyk";
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
