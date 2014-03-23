{ cabal, binary, eventList, explicitException, monoidTransformer
, nonNegative, QuickCheck, random, transformers, utilityHt
}:

cabal.mkDerivation (self: {
  pname = "midi";
  version = "0.2.1.1";
  sha256 = "11h4kr9a1jia1ghcyzgavcznw4771l00z736iibjpagw0b8fpip5";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    binary eventList explicitException monoidTransformer nonNegative
    QuickCheck random transformers utilityHt
  ];
  meta = {
    homepage = "http://www.haskell.org/haskellwiki/MIDI";
    description = "Handling of MIDI messages and files";
    license = "GPL";
    platforms = self.ghc.meta.platforms;
  };
})
