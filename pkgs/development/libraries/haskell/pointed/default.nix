{ cabal, comonad, dataDefaultClass, semigroupoids, semigroups, stm
, tagged, transformers
}:

cabal.mkDerivation (self: {
  pname = "pointed";
  version = "4.0";
  sha256 = "02y7ba1pcpmwcp762516p4x75y3ma2kml9mbiv1y8gcnn4ylvir4";
  buildDepends = [
    comonad dataDefaultClass semigroupoids semigroups stm tagged
    transformers
  ];
  meta = {
    homepage = "http://github.com/ekmett/pointed/";
    description = "Pointed and copointed data";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
