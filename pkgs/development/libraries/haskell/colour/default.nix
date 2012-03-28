{ cabal }:

cabal.mkDerivation (self: {
  pname = "colour";
  version = "2.3.3";
  sha256 = "1qmn1778xzg07jg9nx4k1spdz2llivpblf6wwrps1qpqjhsac5cd";
  meta = {
    homepage = "http://www.haskell.org/haskellwiki/Colour";
    description = "A model for human colour/color perception";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
