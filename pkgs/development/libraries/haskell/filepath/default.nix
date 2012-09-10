{ cabal }:

cabal.mkDerivation (self: {
  pname = "filepath";
  version = "1.3.0.1";
  sha256 = "1ny8dz8rv883vg6hkzg3zank771cr2z9sfhii7aw4rfb71k29g5p";
  meta = {
    homepage = "http://www-users.cs.york.ac.uk/~ndm/filepath/";
    description = "Library for manipulating FilePaths in a cross platform way";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
