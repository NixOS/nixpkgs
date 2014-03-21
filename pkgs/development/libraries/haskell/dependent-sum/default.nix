{ cabal }:

cabal.mkDerivation (self: {
  pname = "dependent-sum";
  version = "0.2.0.2";
  sha256 = "06amnc50j246f2za0ri49j6vyq6admx03w3xxjhhfnfx9lp6zmhm";
  meta = {
    homepage = "https://github.com/mokus0/dependent-sum";
    description = "Dependent sum type";
    license = self.stdenv.lib.licenses.publicDomain;
    platforms = self.ghc.meta.platforms;
  };
})
