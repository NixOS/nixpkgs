{ cabal, Cabal, text }:

cabal.mkDerivation (self: {
  pname = "double-conversion";
  version = "0.2.0.4";
  sha256 = "00rb8n2ky20ah9ry398jagi9gb0gz40yjfalh35cpckmg30z199x";
  buildDepends = [ Cabal text ];
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
