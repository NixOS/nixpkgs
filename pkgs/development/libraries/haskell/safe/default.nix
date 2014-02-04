{ cabal }:

cabal.mkDerivation (self: {
  pname = "safe";
  version = "0.3.4";
  sha256 = "0mwdaj0sjvqkgg077x1d896xphx64yrjvwbdhv7khdk3rh0vfl64";
  meta = {
    homepage = "http://community.haskell.org/~ndm/safe/";
    description = "Library for safe (pattern match free) functions";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
