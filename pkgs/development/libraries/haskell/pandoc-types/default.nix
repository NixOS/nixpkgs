{ cabal, syb }:

cabal.mkDerivation (self: {
  pname = "pandoc-types";
  version = "1.9.0.2";
  sha256 = "1rqqchxinjk3njgkp73i92q4iz1cl84p56i2fmgj2zn221r0zhyl";
  buildDepends = [ syb ];
  meta = {
    homepage = "http://johnmacfarlane.net/pandoc";
    description = "Types for representing a structured document";
    license = "GPL";
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
