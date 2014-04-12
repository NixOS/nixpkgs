{ cabal, cairo, Chart, colour, dataDefaultClass, lens, mtl
, operational, time
}:

cabal.mkDerivation (self: {
  pname = "Chart-cairo";
  version = "1.2.2";
  sha256 = "1bbi5bvrh8wmgzv5am5ndgdr68gd68ipparkkk9ld4majwf4vm6w";
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
