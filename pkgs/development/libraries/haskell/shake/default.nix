{ cabal, binary, deepseq, filepath, hashable, random, time
, transformers, unorderedContainers, utf8String
}:

cabal.mkDerivation (self: {
  pname = "shake";
  version = "0.10.8";
  sha256 = "15r392b18nis9p0ys95kbj79hki19wid2gyrpy0z9zm2l5d1m3ya";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    binary deepseq filepath hashable random time transformers
    unorderedContainers utf8String
  ];
  testDepends = [
    binary deepseq filepath hashable random time transformers
    unorderedContainers utf8String
  ];
  doCheck = false;
  meta = {
    homepage = "http://community.haskell.org/~ndm/shake/";
    description = "Build system library, like Make, but more accurate dependencies";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
