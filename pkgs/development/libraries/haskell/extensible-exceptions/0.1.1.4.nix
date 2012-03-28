{ cabal }:

cabal.mkDerivation (self: {
  pname = "extensible-exceptions";
  version = "0.1.1.4";
  sha256 = "1273nqws9ij1rp1bsq5jc7k2jxpqa0svawdbim05lf302y0firbc";
  meta = {
    description = "Extensible exceptions";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
