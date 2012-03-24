{ cabal, csv, html, mtl }:

cabal.mkDerivation (self: {
  pname = "tabular";
  version = "0.2.2.3";
  sha256 = "cf6d9f1928ec6981edcbb06c4dcbaea7a96deef5272192ad4290caa18711ea76";
  buildDepends = [ csv html mtl ];
  meta = {
    homepage = "http://patch-tag.com/r/kowey/tabular";
    description = "Two-dimensional data tables with rendering functions";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
