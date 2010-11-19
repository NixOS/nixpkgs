{cabal, cairo, colour, dataAccessor, dataAccessorTemplate, gtk, mtl}:

cabal.mkDerivation (self : {
  pname = "Chart";
  version = "0.13.1";
  sha256 = "1gh8qw8xil543wssflhpjrgnig4v79vi7xizrm93a93i4n84npd5";
  propagatedBuildInputs =
    [cairo colour dataAccessor dataAccessorTemplate gtk mtl];
  meta = {
    description = "A library for generating 2D Charts and Plots";
    license = "BSD";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})  

