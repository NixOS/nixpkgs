{ cabal, cairo, colour, dataAccessor, dataAccessorTemplate, mtl
, time
}:

cabal.mkDerivation (self: {
  pname = "Chart";
  version = "0.16";
  sha256 = "1mb8hgxj0i5s7l061pfn49m5f6qdwvmgy6ni7jmg85vpy6b7jra3";
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
