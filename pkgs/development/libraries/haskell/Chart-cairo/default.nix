{ cabal, cairo, Chart, colour, dataDefaultClass, mtl, operational
, time
}:

cabal.mkDerivation (self: {
  pname = "Chart-cairo";
  version = "1.0";
  sha256 = "0z5qhsq9v5sd32d18gl09svxic8n6s65v4nyq04zcp76219mhp55";
  buildDepends = [
    cairo Chart colour dataDefaultClass mtl operational time
  ];
  meta = {
    homepage = "https://github.com/timbod7/haskell-chart/wiki";
    description = "Cairo backend for Charts";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
