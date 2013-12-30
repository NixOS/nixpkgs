{ cabal, hspec, QuickCheck }:

cabal.mkDerivation (self: {
  pname = "errorcall-eq-instance";
  version = "0.1.0";
  sha256 = "1sr2wxbdqzpdawcivvd01nwpki0xbcxylz5qv95b96sq6b296gkk";
  testDepends = [ hspec QuickCheck ];
  meta = {
    description = "An orphan Eq instance for ErrorCall";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
