{ cabal }:

cabal.mkDerivation (self: {
  pname = "entropy";
  version = "0.2.2";
  sha256 = "1zri5qs19cbz9ydbh076q6834pspf2gqn06ssz4hsq6j65cnd9x2";
  meta = {
    homepage = "https://github.com/TomMD/entropy";
    description = "A platform independent entropy source";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
