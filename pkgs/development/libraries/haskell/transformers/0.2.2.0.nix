{ cabal }:

cabal.mkDerivation (self: {
  pname = "transformers";
  version = "0.2.2.0";
  sha256 = "1nkazxy2p0w5ad76vg1lc4l0nla1kdqjdf9pymjgk75dpiyijbdz";
  meta = {
    description = "Concrete functor and monad transformers";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
