{ cabal, binary, deepseq, filepath, hashable, QuickCheck, random
, time, transformers, unorderedContainers, utf8String
}:

cabal.mkDerivation (self: {
  pname = "shake";
  version = "0.13.1";
  sha256 = "00dvf1ydfgpnkv09fywsvyn0sphjwdrqhvkc21axj580ykbqxrn7";
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
