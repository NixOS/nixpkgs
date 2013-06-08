{ cabal, hspec, QuickCheck }:

cabal.mkDerivation (self: {
  pname = "stringbuilder";
  version = "0.4.0";
  sha256 = "0v0lpb13khpiygfdkyzzsf64anxjykwvjsrkds836whm1bv86lhl";
  testDepends = [ hspec QuickCheck ];
  meta = {
    description = "A writer monad for multi-line string literals";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
