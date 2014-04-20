{ cabal, async, deepseq, hspec, liftedBase, monadControl
, QuickCheck, transformers
}:

cabal.mkDerivation (self: {
  pname = "enclosed-exceptions";
  version = "1.0.0.1";
  sha256 = "0imq5kp45yfkhkz51ld869pf9hnlkbh92nk0aig1z8cc6akjnjw0";
  buildDepends = [
    async deepseq liftedBase monadControl transformers
  ];
  testDepends = [
    async deepseq hspec liftedBase monadControl QuickCheck transformers
  ];
  meta = {
    homepage = "https://github.com/jcristovao/enclosed-exceptions";
    description = "Catching all exceptions from within an enclosed computation";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
