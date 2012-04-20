{ cabal, hashable, primitive, vector }:

cabal.mkDerivation (self: {
  pname = "hashtables";
  version = "1.0.1.4";
  sha256 = "1s1xj5x90dz9n85bkmjpdp8zwnvvv13m19aaxzi63n3iyn4jki33";
  buildDepends = [ hashable primitive vector ];
  meta = {
    homepage = "http://github.com/gregorycollins/hashtables";
    description = "Mutable hash tables in the ST monad";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
