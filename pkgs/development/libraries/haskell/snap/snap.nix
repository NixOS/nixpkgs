{ cabal, aeson, attoparsec, cereal, clientsession, comonad
, configurator, directoryTree, dlist, errors, filepath, hashable
, heist, lens, logict, MonadCatchIOTransformers, mtl, mwcRandom
, pwstoreFast, regexPosix, snapCore, snapServer, stm, syb, text
, time, transformers, unorderedContainers, vector, vectorAlgorithms
, xmlhtml
}:

cabal.mkDerivation (self: {
  pname = "snap";
  version = "0.13.2.1";
  sha256 = "0jkjxyw7pcfl8r6gs0amzpkxardncvxsh20m7lad6aqjkcwh8r4l";
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
