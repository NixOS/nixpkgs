{ cabal, binary, deepseq, filepath, hashable, QuickCheck, random
, time, transformers, unorderedContainers, utf8String
}:

cabal.mkDerivation (self: {
  pname = "shake";
  version = "0.10.9";
  sha256 = "08czcf0pkchq558kjkfpz7vf5pn1dbqk8mb9fnivnphy963sf6sr";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    binary deepseq filepath hashable random time transformers
    unorderedContainers utf8String
  ];
  testDepends = [
    binary deepseq filepath hashable QuickCheck random time
    transformers unorderedContainers utf8String
  ];
  meta = {
    homepage = "https://github.com/ndmitchell/shake";
    description = "Build system library, like Make, but more accurate dependencies";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
