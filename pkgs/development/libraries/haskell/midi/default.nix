{ cabal, binary, eventList, explicitException, monoidTransformer
, nonNegative, QuickCheck, random, transformers, utilityHt
}:

cabal.mkDerivation (self: {
  pname = "midi";
  version = "0.2.1";
  sha256 = "0i767y0835979s9i3wm8qwzh2awhhmfvhc5zvq2lkn8xlsp3wa6y";
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
