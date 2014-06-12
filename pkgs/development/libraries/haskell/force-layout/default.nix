{ cabal, dataDefaultClass, lens, vectorSpace, vectorSpacePoints }:

cabal.mkDerivation (self: {
  pname = "force-layout";
  version = "0.3.0.5";
  sha256 = "01wk8zygw9d3r5dwbycyab82kfk8s05ynnajb6kfjv7i09s9sgcb";
  buildDepends = [
    dataDefaultClass lens vectorSpace vectorSpacePoints
  ];
  meta = {
    description = "Simple force-directed layout";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
