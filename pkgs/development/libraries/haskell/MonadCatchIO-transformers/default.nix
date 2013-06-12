{ cabal, extensibleExceptions, transformers }:

cabal.mkDerivation (self: {
  pname = "MonadCatchIO-transformers";
  version = "0.3.0.0";
  sha256 = "0v7k6npfr1x9s4bk409y6sc1vhzs5pm4mwpky356z7kdvz2z274c";
  buildDepends = [ extensibleExceptions transformers ];
  meta = {
    description = "Monad-transformer compatible version of the Control.Exception module";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
