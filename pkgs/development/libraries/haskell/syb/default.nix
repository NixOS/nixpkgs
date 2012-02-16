{ cabal }:

cabal.mkDerivation (self: {
  pname = "syb";
  version = "0.1.0.1";
  sha256 = "08nf4id26s5iasxzdy5jds6h87fy3a55zgw0zrig4dg6difmwjp3";
  meta = {
    description = "Scrap Your Boilerplate";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
