{ cabal }:

cabal.mkDerivation (self: {
  pname = "safe";
  version = "0.3.2";
  sha256 = "1gblidpsz2zyr5aw5c9ggxzx3firdz7s7iai9vf9gc5mv9vnnggv";
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
