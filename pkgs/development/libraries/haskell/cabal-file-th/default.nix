{ cabal }:

cabal.mkDerivation (self: {
  pname = "cabal-file-th";
  version = "0.2.1";
  sha256 = "0nczwicgf6kx3lk5m7wqf1wj6ghn8jfx112dzh7jh4f4xs66nsd1";
  meta = {
    homepage = "http://github.com/nkpart/cabal-file-th";
    description = "Template Haskell expressions for reading fields from a project's cabal file";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
