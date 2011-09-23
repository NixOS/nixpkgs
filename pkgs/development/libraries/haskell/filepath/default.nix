{ cabal }:

cabal.mkDerivation (self: {
  pname = "filepath";
  version = "1.2.0.1";
  sha256 = "1fq62kxf68y2952qhipllz049cq52yc3wm4i31v2lg5hdcwbw152";
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
