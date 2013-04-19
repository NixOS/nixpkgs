{ cabal, aeson, attoparsec, cereal, clientsession, comonad
, configurator, directoryTree, dlist, errors, filepath, hashable
, heist, lens, logict, MonadCatchIOTransformers, mtl, mwcRandom
, pwstoreFast, regexPosix, snapCore, snapServer, stm, syb, tagged
, text, time, transformers, unorderedContainers, vector
, vectorAlgorithms, xmlhtml
}:

cabal.mkDerivation (self: {
  pname = "snap";
  version = "0.11.2.2";
  sha256 = "1fwm60rx2ginlphi00kn3ghs9rxdx4br8p4f3prpfmhvjikwgv8n";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    aeson attoparsec cereal clientsession comonad configurator
    directoryTree dlist errors filepath hashable heist lens logict
    MonadCatchIOTransformers mtl mwcRandom pwstoreFast regexPosix
    snapCore snapServer stm syb tagged text time transformers
    unorderedContainers vector vectorAlgorithms xmlhtml
  ];
  jailbreak = true;
  meta = {
    homepage = "http://snapframework.com/";
    description = "Top-level package for the Snap Web Framework";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.simons ];
  };
})
