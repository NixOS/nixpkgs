{ cabal, cairo, colour, dataAccessor, dataAccessorTemplate, gtk
, mtl, time
}:

cabal.mkDerivation (self: {
  pname = "Chart";
  version = "0.14";
  sha256 = "0ji81j4c2by5zyrdhx1s17j6kqsi3ngr9y1zh7hr9wv7jsrj3rf2";
  buildDepends = [
    cairo colour dataAccessor dataAccessorTemplate gtk mtl time
  ];
  meta = {
    homepage = "http://www.dockerz.net/software/chart.html";
    description = "A library for generating 2D Charts and Plots";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
