{ cabal, aeson, attoparsec, cereal, clientsession, configurator
, dataLens, dataLensTemplate, directoryTree, filepath, hashable
, heist, logict, MonadCatchIOTransformers, mtl, mwcRandom
, pwstoreFast, snapCore, snapServer, stm, syb, text, time
, transformers, unorderedContainers, utf8String, vector
, vectorAlgorithms, xmlhtml
}:

cabal.mkDerivation (self: {
  pname = "snap";
  version = "0.9.0.1";
  sha256 = "0n3qmyvqqcds3c56ml77d2cr0ghs1c7wwd20m44zzmxxmpbnfmgh";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    aeson attoparsec cereal clientsession configurator dataLens
    dataLensTemplate directoryTree filepath hashable heist logict
    MonadCatchIOTransformers mtl mwcRandom pwstoreFast snapCore
    snapServer stm syb text time transformers unorderedContainers
    utf8String vector vectorAlgorithms xmlhtml
  ];
  meta = {
    homepage = "http://snapframework.com/";
    description = "Snap: A Haskell Web Framework: project starter executable and glue code library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
