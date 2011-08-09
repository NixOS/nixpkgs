{ cabal }:

cabal.mkDerivation (self: {
  pname = "colour";
  version = "2.3.1";
  sha256 = "58cf12b8abf7d01a752b1b778b64cc406903874702e3475d65c2aa35689fa49b";
  meta = {
    homepage = "http://www.haskell.org/haskellwiki/Colour";
    description = "A model for human colour/color perception";
    license = "unknown";
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
