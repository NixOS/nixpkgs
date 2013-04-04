{ cabal }:

cabal.mkDerivation (self: {
  pname = "gdiff";
  version = "1.0";
  sha256 = "35257b1090cf78f95d24c7a89920863c1d824652311fa5793693d7d06d96517b";
  meta = {
    description = "Generic diff and patch";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
