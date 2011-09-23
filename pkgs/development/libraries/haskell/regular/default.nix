{ cabal }:

cabal.mkDerivation (self: {
  pname = "regular";
  version = "0.3.3";
  sha256 = "1xlpp60nvdiqkcn66dnpww72hcawyc1w7cd9zk9kk88x574kqzf7";
  meta = {
    description = "Generic programming library for regular datatypes";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
