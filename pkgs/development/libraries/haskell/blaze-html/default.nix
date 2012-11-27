{ cabal, blazeBuilder, blazeMarkup, text }:

cabal.mkDerivation (self: {
  pname = "blaze-html";
  version = "0.5.1.1";
  sha256 = "1z1lnfph4spy9vx2nfhbykkfcdnw14fars5aydrgi70spaq5ial2";
  buildDepends = [ blazeBuilder blazeMarkup text ];
  meta = {
    homepage = "http://jaspervdj.be/blaze";
    description = "A blazingly fast HTML combinator library for Haskell";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
