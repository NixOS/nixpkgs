{ cabal, aeson, attoparsec, cereal, clientsession, comonad
, configurator, directoryTree, dlist, errors, filepath, hashable
, heist, lens, logict, MonadCatchIOTransformers, mtl, mwcRandom
, pwstoreFast, regexPosix, snapCore, snapServer, stm, syb, text
, time, transformers, unorderedContainers, vector, vectorAlgorithms
, xmlhtml
}:

cabal.mkDerivation (self: {
  pname = "snap";
  version = "0.13.2.4";
  sha256 = "1806nd6gzih66c9gg2iz3dxr4qcd4jkgamz8pv9x3zkk7n5jqga0";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    aeson attoparsec cereal clientsession comonad configurator
    directoryTree dlist errors filepath hashable heist lens logict
    MonadCatchIOTransformers mtl mwcRandom pwstoreFast regexPosix
    snapCore snapServer stm syb text time transformers
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
