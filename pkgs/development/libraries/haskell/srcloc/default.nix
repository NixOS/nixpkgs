{ cabal, syb }:

cabal.mkDerivation (self: {
  pname = "srcloc";
  version = "0.2.0";
  sha256 = "1p63gachz8ccv61ih3jb995kcg72g7vkihryb2ak7d8bxxxx3irs";
  buildDepends = [ syb ];
  noHaddock = true;
  meta = {
    homepage = "http://www.eecs.harvard.edu/~mainland/";
    description = "Data types for managing source code locations";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
