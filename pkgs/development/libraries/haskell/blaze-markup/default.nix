{ cabal, blazeBuilder, text }:

cabal.mkDerivation (self: {
  pname = "blaze-markup";
  version = "0.5.1.0";
  sha256 = "0vq0xzwa13sjybg6zdi3ynsn6yxyl1q6rbalvb9r6f3plrmik37a";
  buildDepends = [ blazeBuilder text ];
  meta = {
    homepage = "http://jaspervdj.be/blaze";
    description = "A blazingly fast markup combinator library for Haskell";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
