{ cabal, cairo, Chart, colour, dataDefaultClass, lens, mtl
, operational, time
}:

cabal.mkDerivation (self: {
  pname = "Chart-cairo";
  version = "1.1";
  sha256 = "0pm8iwd83pn5ba0g3231zs7f39cdjr7n7k76cm642n4b0hf93fmb";
  buildDepends = [
    cairo Chart colour dataDefaultClass lens mtl operational time
  ];
  meta = {
    homepage = "https://github.com/timbod7/haskell-chart/wiki";
    description = "Cairo backend for Charts";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
