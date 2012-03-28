{ cabal }:

cabal.mkDerivation (self: {
  pname = "mmap";
  version = "0.5.7";
  sha256 = "0f08x9kmv3a03kz5a6dpxr30nks55cs9sp55qpn2jnw31qx6hg6p";
  isLibrary = true;
  isExecutable = true;
  meta = {
    description = "Memory mapped files for POSIX and Windows";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
