{ cabal, binary, deepseq, filepath, hashable, QuickCheck, random
, time, transformers, unorderedContainers, utf8String
}:

cabal.mkDerivation (self: {
  pname = "shake";
  version = "0.11.2";
  sha256 = "1mhll4h6za67pjcm4amdcibfd7ny2kfx4mfws0lrd903j1p5b00q";
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
