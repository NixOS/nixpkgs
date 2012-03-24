{ cabal }:

cabal.mkDerivation (self: {
  pname = "syb";
  version = "0.3.5";
  sha256 = "17gwhn0rqjf9zkx1dsmsaj41qdjlk4mq5lzpqkgy3slq30nwwwbr";
  meta = {
    homepage = "http://www.cs.uu.nl/wiki/GenericProgramming/SYB";
    description = "Scrap Your Boilerplate";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
