{ cabal }:

cabal.mkDerivation (self: {
  pname = "mmap";
  version = "0.5.9";
  sha256 = "1y5mk3yf4b8r6rzmlx1xqn4skaigrqnv08sqq0v7r3nbw42bpz2q";
  isLibrary = true;
  isExecutable = true;
  meta = {
    description = "Memory mapped files for POSIX and Windows";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
