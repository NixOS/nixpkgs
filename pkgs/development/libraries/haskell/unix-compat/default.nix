{ cabal }:

cabal.mkDerivation (self: {
  pname = "unix-compat";
  version = "0.4.1.1";
  sha256 = "1cjny6zca5wdj7d56kjkaxlad85kknn91pisrizjy6wngszyaigf";
  meta = {
    homepage = "http://github.com/jystic/unix-compat";
    description = "Portable POSIX-compatibility layer";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
