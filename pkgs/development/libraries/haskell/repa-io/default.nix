{ cabal, bmp, repa, repaBytestring }:

cabal.mkDerivation (self: {
  pname = "repa-io";
  version = "2.1.0.1";
  sha256 = "1mjv90rr1vymrnv5kz8i4kvjal6mwhb2042ylbdggvv8hjsc8awq";
  buildDepends = [ bmp repa repaBytestring ];
  meta = {
    homepage = "http://repa.ouroborus.net";
    description = "Read and write Repa arrays in various formats.";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
