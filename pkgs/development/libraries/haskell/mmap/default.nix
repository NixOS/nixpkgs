{ cabal }:

cabal.mkDerivation (self: {
  pname = "mmap";
  version = "0.5.8";
  sha256 = "17zsb95ynyrqj51h4jxi9glsih4vq33hbxycgw13z5fivv261m7y";
  isLibrary = true;
  isExecutable = true;
  meta = {
    description = "Memory mapped files for POSIX and Windows";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
