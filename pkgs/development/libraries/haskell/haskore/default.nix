{ cabal, dataAccessor, eventList, haskellSrc, markovChain, midi
, nonNegative, parsec, random, transformers, utilityHt
}:

cabal.mkDerivation (self: {
  pname = "haskore";
  version = "0.2.0.3";
  sha256 = "0vg4m2cmy1fabfnck9v22jicflb0if64h0wjvyrgpn2ykb9wwbpa";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    dataAccessor eventList haskellSrc markovChain midi nonNegative
    parsec random transformers utilityHt
  ];
  meta = {
    homepage = "http://www.haskell.org/haskellwiki/Haskore";
    description = "The Haskore Computer Music System";
    license = "GPL";
    platforms = self.ghc.meta.platforms;
  };
})
