{ cabal, dataDefaultClass, dataDefaultInstancesBase
, dataDefaultInstancesContainers, dataDefaultInstancesDlist
, dataDefaultInstancesOldLocale
}:

cabal.mkDerivation (self: {
  pname = "data-default";
  version = "0.5.2";
  sha256 = "1w9wqv3k579zp5w11v06fak0lr9zzads49b1c9rb1vkz1d8bvf82";
  buildDepends = [
    dataDefaultClass dataDefaultInstancesBase
    dataDefaultInstancesContainers dataDefaultInstancesDlist
    dataDefaultInstancesOldLocale
  ];
  meta = {
    description = "A class for types with a default value";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
