{ cabal, parsec }:

cabal.mkDerivation (self: {
  pname = "network";
  version = "2.3.0.14";
  sha256 = "0naqg7ai50m3p093mi342w2z0flaagarf9n9smkn1dqvq8jg75x5";
  buildDepends = [ parsec ];
  meta = {
    homepage = "http://github.com/haskell/network";
    description = "Low-level networking interface";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
