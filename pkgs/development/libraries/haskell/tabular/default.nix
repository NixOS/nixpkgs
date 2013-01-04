{ cabal, csv, html, mtl }:

cabal.mkDerivation (self: {
  pname = "tabular";
  version = "0.2.2.4";
  sha256 = "103fqbypsgykv6z29jp1s75pd99vra9sfa70krcnlhbk9kbvdyjk";
  buildDepends = [ csv html mtl ];
  meta = {
    homepage = "http://hub.darcs.net/kowey/tabular";
    description = "Two-dimensional data tables with rendering functions";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
