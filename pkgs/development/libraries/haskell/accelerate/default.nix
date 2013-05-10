{ cabal }:

cabal.mkDerivation (self: {
  pname = "accelerate";
  version = "0.12.2.0";
  sha256 = "1fv7d2prpkwy2gy0llafksayka76jv8c0sd66x6632gb586pfwgs";
  meta = {
    homepage = "https://github.com/AccelerateHS/accelerate/";
    description = "An embedded language for accelerated array processing";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
