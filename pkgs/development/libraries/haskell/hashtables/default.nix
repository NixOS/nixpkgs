{ cabal, hashable, primitive, vector }:

cabal.mkDerivation (self: {
  pname = "hashtables";
  version = "1.0.1.7";
  sha256 = "0swk501whj08jj9q1d1lwg06nakimxnr7797zx8y8275f5mmisi7";
  buildDepends = [ hashable primitive vector ];
  meta = {
    homepage = "http://github.com/gregorycollins/hashtables";
    description = "Mutable hash tables in the ST monad";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
