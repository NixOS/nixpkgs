{ cabal, dataDefaultClass, lens, vectorSpace, vectorSpacePoints }:

cabal.mkDerivation (self: {
  pname = "force-layout";
  version = "0.3.0.3";
  sha256 = "0xix9syfiya5wx0iwzs7sp3ksqyp15vjlpir71x8md8v0hkrnh5a";
  buildDepends = [
    dataDefaultClass lens vectorSpace vectorSpacePoints
  ];
  meta = {
    description = "Simple force-directed layout";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
