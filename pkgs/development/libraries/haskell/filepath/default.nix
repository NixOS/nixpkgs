{ cabal }:

cabal.mkDerivation (self: {
  pname = "filepath";
  version = "1.3.0.0";
  sha256 = "1v5affq82b4fypm49d5sradcx4ymgmkac563vfx483pmyl73i5jl";
  meta = {
    homepage = "http://www-users.cs.york.ac.uk/~ndm/filepath/";
    description = "Library for manipulating FilePaths in a cross platform way";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
