{ cabal, dataAccessor, transformers }:

cabal.mkDerivation (self: {
  pname = "data-accessor-transformers";
  version = "0.2.1.4";
  sha256 = "1bf1j8g5q81zw51bri89hj3i9jnlmhdggw8rhw3n2v103399pf7d";
  buildDepends = [ dataAccessor transformers ];
  meta = {
    homepage = "http://www.haskell.org/haskellwiki/Record_access";
    description = "Use Accessor to access state in transformers State monad";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
