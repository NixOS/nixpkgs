{ cabal, baseUnicodeSymbols, transformers }:

cabal.mkDerivation (self: {
  pname = "monad-control";
  version = "0.2.0.2";
  sha256 = "18kakshbjr6nspc6m2ckpbi3sx7r10qmmbh8qbzibg19n9mnq2ni";
  buildDepends = [ baseUnicodeSymbols transformers ];
  meta = {
    homepage = "https://github.com/basvandijk/monad-control/";
    description = "Lift control operations, like exception catching, through monad transformers";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
