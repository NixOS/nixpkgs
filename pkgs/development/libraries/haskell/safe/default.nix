{ cabal }:

cabal.mkDerivation (self: {
  pname = "safe";
  version = "0.3.1";
  sha256 = "0sq4fcwh9bmhi79rnxh70hqwa2k3sipqnvq0f9a78j4wg6nmm6li";
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
