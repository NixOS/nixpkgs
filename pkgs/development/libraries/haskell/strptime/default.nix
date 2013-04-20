{ cabal, text, time }:

cabal.mkDerivation (self: {
  pname = "strptime";
  version = "1.0.10";
  sha256 = "1f42yf49fqr2fyjfakscmmlnmw3w5rg7wyy6gjyrf0gcgsh0h9fd";
  buildDepends = [ text time ];
  meta = {
    description = "Efficient parsing of LocalTime using a binding to C's strptime, with some extra features (i.e. fractional seconds)";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.simons ];
  };
})
