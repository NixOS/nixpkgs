{ cabal, blazeBuilder, blazeMarkup, text }:

cabal.mkDerivation (self: {
  pname = "blaze-html";
  version = "0.5.1.3";
  sha256 = "0ia7pk346lc7664w859q09p163cxgxjjpkk7cbmbl1wj2shshh1w";
  buildDepends = [ blazeBuilder blazeMarkup text ];
  meta = {
    homepage = "http://jaspervdj.be/blaze";
    description = "A blazingly fast HTML combinator library for Haskell";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
