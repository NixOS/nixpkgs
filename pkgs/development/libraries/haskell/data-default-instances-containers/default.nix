{ cabal, dataDefaultClass }:

cabal.mkDerivation (self: {
  pname = "data-default-instances-containers";
  version = "0.0.1";
  sha256 = "06h8xka031w752a7cjlzghvr8adqbl95xj9z5zc1b62w02phfpm5";
  buildDepends = [ dataDefaultClass ];
  meta = {
    description = "Default instances for types in containers";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.simons ];
  };
})
