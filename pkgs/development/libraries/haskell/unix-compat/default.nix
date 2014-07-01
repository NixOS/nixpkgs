{ cabal }:

cabal.mkDerivation (self: {
  pname = "unix-compat";
  version = "0.4.1.3";
  sha256 = "1vfw3ffzdk9mshhgyp3dnbn8rihkz8qg6n5zqak8966dsdqhm4xb";
  meta = {
    homepage = "http://github.com/jystic/unix-compat";
    description = "Portable POSIX-compatibility layer";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
