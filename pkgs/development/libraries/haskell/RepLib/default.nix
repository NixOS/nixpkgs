{ cabal, mtl, typeEquality }:

cabal.mkDerivation (self: {
  pname = "RepLib";
  version = "0.5.3";
  sha256 = "1kpd4qli6fclrr3i21kmdwbpa0la7ssi9pgagzclr3yj2ca2hsgw";
  buildDepends = [ mtl typeEquality ];
  meta = {
    homepage = "http://code.google.com/p/replib/";
    description = "Generic programming library with representation types";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
