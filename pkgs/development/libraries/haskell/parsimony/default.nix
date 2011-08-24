{ cabal, utf8String }:

cabal.mkDerivation (self: {
  pname = "parsimony";
  version = "1.1";
  sha256 = "0476zmsjyjf58lh85806baqblq8hjxcrrnqc6ddxxq17lmvsd5ic";
  buildDepends = [ utf8String ];
  meta = {
    description = "Monadic parser combinators derived from Parsec";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
