{ cabal }:

cabal.mkDerivation (self: {
  pname = "circle-packing";
  version = "0.1.0.2";
  sha256 = "182fadwlf6j3jhlfjskaddaickgcb07wlb7fh42yip2680gh9k1j";
  meta = {
    description = "Simple heuristic for packing discs of varying radii in a circle";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
