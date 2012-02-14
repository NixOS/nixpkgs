{ cabal, Cabal, ListLike, time }:

cabal.mkDerivation (self: {
  pname = "uu-parsinglib";
  version = "2.7.3.2";
  sha256 = "0z53s9wvk57g3d9x3iswjydwm7nw5vfrj7k08v75fw6rwldkal60";
  buildDepends = [ Cabal ListLike time ];
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
