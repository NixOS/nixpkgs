{ cabal }:

cabal.mkDerivation (self: {
  pname = "unix-compat";
  version = "0.4.0.0";
  sha256 = "0xhhvqdjcmcyavf0g2q2sjghj2h4si1ijg4nc4s8kidbd957z9r8";
  meta = {
    homepage = "http://github.com/jystic/unix-compat";
    description = "Portable POSIX-compatibility layer";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
