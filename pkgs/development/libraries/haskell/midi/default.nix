{ cabal, binary, eventList, explicitException, monoidTransformer
, nonNegative, QuickCheck, random, transformers, utilityHt
}:

cabal.mkDerivation (self: {
  pname = "midi";
  version = "0.2.1.3";
  sha256 = "0mqf6q7686zdxljkz3bqa2zhkgirqz5c1fkbd3n4wyipzhjc773a";
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
