{ cabal, cairo, Chart, colour, dataDefaultClass, lens, mtl
, operational, time
}:

cabal.mkDerivation (self: {
  pname = "Chart-cairo";
  version = "1.2";
  sha256 = "08aaf7yb2vry75g15md2012rnmyfrn7awwvba7c38d4h6vm95llg";
  buildDepends = [
    cairo Chart colour dataDefaultClass lens mtl operational time
  ];
  jailbreak = true;
  meta = {
    homepage = "https://github.com/timbod7/haskell-chart/wiki";
    description = "Cairo backend for Charts";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
