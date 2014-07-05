{ cabal, cairo, Chart, colour, dataDefaultClass, lens, mtl
, operational, time
}:

cabal.mkDerivation (self: {
  pname = "Chart-cairo";
  version = "1.2.3";
  sha256 = "1lbl1qvgm4yxslahlms6kzfrhh8s2fcdiwmvk1bs319k1fylia1b";
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
