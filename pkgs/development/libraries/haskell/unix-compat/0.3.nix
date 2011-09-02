{ cabal }:

cabal.mkDerivation (self: {
  pname = "unix-compat";
  version = "0.3";
  sha256 = "0zgz9s5z2kca37sgnf4dyfdw90435h20bznx485y1ggvh377jan7";
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
