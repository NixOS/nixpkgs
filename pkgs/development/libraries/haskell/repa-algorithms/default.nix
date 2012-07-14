{ cabal, llvm, repa, vector }:

cabal.mkDerivation (self: {
  pname = "repa-algorithms";
  version = "3.2.1.1";
  sha256 = "19gc2vbkqxysnm0argksn8c3cv7vf30hkdycgv8fdfn0yc95xz0v";
  buildDepends = [ repa vector ];
  extraLibraries = [ llvm ];
  meta = {
    homepage = "http://repa.ouroborus.net";
    description = "Algorithms using the Repa array library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
