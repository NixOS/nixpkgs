{ cabal, ListLike, time }:

cabal.mkDerivation (self: {
  pname = "uu-parsinglib";
  version = "2.7.2.2";
  sha256 = "0na5c2l6q6mzscqha59ma8v5d0j2vh3y5vl51gb7rzwqz4a6hg95";
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
