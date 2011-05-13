{cabal, cairo, colour, dataAccessor, dataAccessorTemplate, gtk, mtl}:

cabal.mkDerivation (self : {
  pname = "Chart";
  version = "0.14";
  sha256 = "0ji81j4c2by5zyrdhx1s17j6kqsi3ngr9y1zh7hr9wv7jsrj3rf2";
  propagatedBuildInputs =
    [cairo colour dataAccessor dataAccessorTemplate gtk mtl];
  meta = {
    description = "A library for generating 2D Charts and Plots";
    license = "BSD";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})

