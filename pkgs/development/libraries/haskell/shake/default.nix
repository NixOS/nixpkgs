{ cabal, binary, deepseq, filepath, hashable, random, time
, transformers, unorderedContainers
}:

cabal.mkDerivation (self: {
  pname = "shake";
  version = "0.10.3";
  sha256 = "0dvpjswiiw2s4zh5sjx7qs4xp41bw2wqny0k61pkg5wvgw3b7jmh";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    binary deepseq filepath hashable random time transformers
    unorderedContainers
  ];
  meta = {
    homepage = "http://community.haskell.org/~ndm/shake/";
    description = "Build system library, like Make, but more accurate dependencies";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
