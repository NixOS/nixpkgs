{ cabal, text }:

cabal.mkDerivation (self: {
  pname = "double-conversion";
  version = "0.2.0.6";
  sha256 = "1c6hy0ghdqf44fvhdpdxjbcr0ahimw283x5fnvjxja36i71qshjp";
  buildDepends = [ text ];
  meta = {
    homepage = "https://github.com/bos/double-conversion";
    description = "Fast conversion between double precision floating point and text";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
