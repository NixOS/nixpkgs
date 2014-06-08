{ cabal, binary, eventList, explicitException, monoidTransformer
, nonNegative, QuickCheck, random, transformers, utilityHt
}:

cabal.mkDerivation (self: {
  pname = "midi";
  version = "0.2.1.2";
  sha256 = "077cxdazr97hjpq42l7hjn905pfhyshvaiwqjdfnzhjv6r48q4zk";
  buildDepends = [
    binary eventList explicitException monoidTransformer nonNegative
    QuickCheck random transformers utilityHt
  ];
  testDepends = [
    eventList explicitException nonNegative QuickCheck transformers
    utilityHt
  ];
  meta = {
    homepage = "http://www.haskell.org/haskellwiki/MIDI";
    description = "Handling of MIDI messages and files";
    license = "GPL";
    platforms = self.ghc.meta.platforms;
  };
})
