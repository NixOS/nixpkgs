{ cabal, aeson, attoparsec, cereal, clientsession, comonad
, configurator, directoryTree, dlist, either, errors, filepath
, hashable, heist, lens, logict, MonadCatchIOTransformers, mtl
, mwcRandom, pwstoreFast, regexPosix, snapCore, snapServer, stm
, syb, text, time, transformers, unorderedContainers, vector
, vectorAlgorithms, xmlhtml
}:

cabal.mkDerivation (self: {
  pname = "snap";
  version = "0.11.0";
  sha256 = "0mw1fxjijd3z9bz1znrc5vfxa4mc1by481gxfmk2hdlcsib9sp7n";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    aeson attoparsec cereal clientsession comonad configurator
    directoryTree dlist either errors filepath hashable heist lens
    logict MonadCatchIOTransformers mtl mwcRandom pwstoreFast
    regexPosix snapCore snapServer stm syb text time transformers
    unorderedContainers vector vectorAlgorithms xmlhtml
  ];
  jailbreak = true;
  meta = {
    homepage = "http://snapframework.com/";
    description = "Top-level package for the Snap Web Framework";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
