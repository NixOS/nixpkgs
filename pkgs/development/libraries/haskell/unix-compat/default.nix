{ cabal }:

cabal.mkDerivation (self: {
  pname = "unix-compat";
  version = "0.4.1.0";
  sha256 = "155m3zg692zbfyck4njx1vzvb5vgs0dkzyzlqf2x78ds6j9bzjzi";
  meta = {
    homepage = "http://github.com/jystic/unix-compat";
    description = "Portable POSIX-compatibility layer";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
