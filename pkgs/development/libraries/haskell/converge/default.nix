{ cabal }:

cabal.mkDerivation (self: {
  pname = "converge";
  version = "0.1.0.1";
  sha256 = "0y28m7kgphknra0w2kzf0g4m2bdj604nr3f22xng46nl7kljbpvj";
  meta = {
    homepage = "/dev/null";
    description = "Limit operations for converging sequences";
    license = self.stdenv.lib.licenses.publicDomain;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
