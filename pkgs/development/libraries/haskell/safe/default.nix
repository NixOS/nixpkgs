{ cabal }:

cabal.mkDerivation (self: {
  pname = "safe";
  version = "0.3.3";
  sha256 = "0ig9laq1p4iic24smjb304mvlsvdyn90lvxh64c4p75c8g459489";
  meta = {
    homepage = "http://community.haskell.org/~ndm/safe/";
    description = "Library for safe (pattern match free) functions";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
