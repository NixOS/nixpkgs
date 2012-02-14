{ cabal, baseUnicodeSymbols, Cabal, dlist }:

cabal.mkDerivation (self: {
  pname = "dstring";
  version = "0.4.0.3";
  sha256 = "0wzj1wzls7w79ac84sc5msblh2dmfmcxm77drpdqdirl1pwdlq9c";
  buildDepends = [ baseUnicodeSymbols Cabal dlist ];
  meta = {
    homepage = "https://github.com/basvandijk/dstring";
    description = "Difference strings";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
