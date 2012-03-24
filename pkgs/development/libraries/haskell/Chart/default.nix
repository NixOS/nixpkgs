{ cabal, cairo, colour, dataAccessor, dataAccessorTemplate, mtl
, time
}:

cabal.mkDerivation (self: {
  pname = "Chart";
  version = "0.15";
  sha256 = "1357gqn2ifalknl85n2z9ysf195dnaxm175rp0kmmzbf4vik9gc4";
  buildDepends = [
    cairo colour dataAccessor dataAccessorTemplate mtl time
  ];
  meta = {
    homepage = "http://www.dockerz.net/software/chart.html";
    description = "A library for generating 2D Charts and Plots";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
