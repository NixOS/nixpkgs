{ cabal }:

cabal.mkDerivation (self: {
  pname = "hscolour";
  version = "1.19";
  sha256 = "17wzd1b7kd4di7djj8d203rn6r1zvd6rykpxhqv7j06kzgx2r7bz";
  isLibrary = true;
  isExecutable = true;
  meta = {
    homepage = "http://code.haskell.org/~malcolm/hscolour/";
    description = "Colourise Haskell code";
    license = "GPL";
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
