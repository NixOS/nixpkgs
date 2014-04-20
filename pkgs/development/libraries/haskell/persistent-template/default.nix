{ cabal, aeson, hspec, monadControl, monadLogger, persistent
, QuickCheck, text, transformers, unorderedContainers
}:

cabal.mkDerivation (self: {
  pname = "persistent-template";
  version = "1.3.1.3";
  sha256 = "0q5ysv1r6p4mg79waq2g6ql11rap6znawkplddblpaa8lq9qalj6";
  buildDepends = [
    aeson monadControl monadLogger persistent text transformers
    unorderedContainers
  ];
  testDepends = [
    aeson hspec persistent QuickCheck text transformers
  ];
  meta = {
    homepage = "http://www.yesodweb.com/book/persistent";
    description = "Type-safe, non-relational, multi-backend persistence";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
