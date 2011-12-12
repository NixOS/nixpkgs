{ cabal, text }:

cabal.mkDerivation (self: {
  pname = "double-conversion";
  version = "0.2.0.3";
  sha256 = "17ny1gvd622rnqjvlrmcpgw3wlabrsc6d046d4ii6xv299z97qw9";
  buildDepends = [ text ];
  meta = {
    homepage = "https://github.com/bos/double-conversion";
    description = "Fast conversion between double precision floating point and text";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
