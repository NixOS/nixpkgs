{ cabal, logict, mtl }:

cabal.mkDerivation (self: {
  pname = "smallcheck";
  version = "1.1";
  sha256 = "167dhi0j4mfmf9idjcfx0x1y1jajx4qmgcpiia93vjpmv8ha56j8";
  buildDepends = [ logict mtl ];
  meta = {
    homepage = "https://github.com/feuerbach/smallcheck";
    description = "A property-based testing library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.ocharles
    ];
  };
})
