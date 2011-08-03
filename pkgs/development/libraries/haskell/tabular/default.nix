{cabal, csv, html}:

cabal.mkDerivation (self : {
  pname = "tabular";
  version = "0.2.2.3";
  sha256 = "cf6d9f1928ec6981edcbb06c4dcbaea7a96deef5272192ad4290caa18711ea76";
  propagatedBuildInputs = [csv html];
  meta = {
    description = "a DSL for describing (and rendering) two-dimensional data tables";
    license = "BSD";
    maintainers = [self.stdenv.lib.maintainers.simons];
  };
})
