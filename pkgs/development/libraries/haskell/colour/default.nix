{ cabal }:

cabal.mkDerivation (self: {
  pname = "colour";
  version = "2.3.2";
  sha256 = "1j0y8cfdzhzjid1hg50qvh5nsa6kfnxcwxaizxyk73z60dn8g9b6";
  meta = {
    homepage = "http://www.haskell.org/haskellwiki/Colour";
    description = "A model for human colour/color perception";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
