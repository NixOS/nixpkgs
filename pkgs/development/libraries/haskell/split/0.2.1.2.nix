{ cabal, QuickCheck }:

cabal.mkDerivation (self: {
  pname = "split";
  version = "0.2.1.2";
  sha256 = "0wjw4j9wgk66h7filzfh0py9b0wwmaynvwqvd6kinxgms86fpvyi";
  testDepends = [ QuickCheck ];
  meta = {
    description = "Combinator library for splitting lists";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
