{ cabal, baseUnicodeSymbols, dlist }:

cabal.mkDerivation (self: {
  pname = "dstring";
  version = "0.4.0.4";
  sha256 = "15zy1dhfs87hxq1qm54ym0pdhvg7l76m7vy5y06dnksb1sblhaqm";
  buildDepends = [ baseUnicodeSymbols dlist ];
  meta = {
    homepage = "https://github.com/basvandijk/dstring";
    description = "Difference strings";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
