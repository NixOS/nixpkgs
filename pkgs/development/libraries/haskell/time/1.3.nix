{ cabal }:

cabal.mkDerivation (self: {
  pname = "time";
  version = "1.3";
  sha256 = "0pkd77qz6lpalj166g91f8nz3mzcpxlzcw83yf8sl5yy4wskhmwz";
  meta = {
    homepage = "http://semantic.org/TimeLib/";
    description = "A time library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
