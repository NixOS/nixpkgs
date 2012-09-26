{ cabal, blazeBuilder, text }:

cabal.mkDerivation (self: {
  pname = "blaze-markup";
  version = "0.5.1.1";
  sha256 = "14va7db8icf2xj7v4i5z0srgv74pf8z6w7046lxs3cyj5pcjl2r9";
  buildDepends = [ blazeBuilder text ];
  meta = {
    homepage = "http://jaspervdj.be/blaze";
    description = "A blazingly fast markup combinator library for Haskell";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
