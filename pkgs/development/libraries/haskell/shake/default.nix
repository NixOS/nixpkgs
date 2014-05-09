{ cabal, binary, deepseq, filepath, hashable, QuickCheck, random
, time, transformers, unorderedContainers, utf8String
}:

cabal.mkDerivation (self: {
  pname = "shake";
  version = "0.12";
  sha256 = "060bvbhk84zagghalg5nh5g17vj8z2kv0qb8vibcq58ahfayj655";
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
