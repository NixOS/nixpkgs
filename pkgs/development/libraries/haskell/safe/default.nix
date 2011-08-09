{ cabal }:

cabal.mkDerivation (self: {
  pname = "safe";
  version = "0.3";
  sha256 = "174jm7nlqsgvc6namjpfknlix6yy2sf9pxnb3ifznjvx18kgc7m0";
  meta = {
    homepage = "http://community.haskell.org/~ndm/safe/";
    description = "Library for safe (pattern match free) functions";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
