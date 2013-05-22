{ cabal }:

cabal.mkDerivation (self: {
  pname = "PSQueue";
  version = "1.1";
  sha256 = "1k291bh8j5vpcrn6vycww2blwg7jxx9yrfmrqdanz48gs4d8gq58";
  meta = {
    description = "Priority Search Queue";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
