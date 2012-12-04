{ cabal, blazeBuilder, text }:

cabal.mkDerivation (self: {
  pname = "blaze-markup";
  version = "0.5.1.2";
  sha256 = "1iqwcmb35793drkvnxx8z3zkyyzd6b84x9b8cp2aza2n0qw7sihm";
  buildDepends = [ blazeBuilder text ];
  meta = {
    homepage = "http://jaspervdj.be/blaze";
    description = "A blazingly fast markup combinator library for Haskell";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
