{ cabal, ListLike, time, uuInterleaved }:

cabal.mkDerivation (self: {
  pname = "uu-parsinglib";
  version = "2.8.1";
  sha256 = "10phjwm8dm45rms2vfpx9vzm56v7b9wp0308xkfbalh5zbvxmv35";
  buildDepends = [ ListLike time uuInterleaved ];
  meta = {
    homepage = "http://www.cs.uu.nl/wiki/bin/view/HUT/ParserCombinators";
    description = "Fast, online, error-correcting, monadic, applicative, merging, permuting, idiomatic parser combinators";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
