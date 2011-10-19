{ cabal }:

cabal.mkDerivation (self: {
  pname = "yap";
  version = "0.1";
  sha256 = "14x1z5pmb499qq5sy0iksxv0mli8556s1jh9jm7rdg671h1cy1hl";
  meta = {
    description = "yet another prelude - a simplistic refactoring with algebraic classes";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
