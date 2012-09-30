{ cabal, aeson, attoparsec, cereal, clientsession, configurator
, dataLens, dataLensTemplate, directoryTree, filepath, hashable
, heist, logict, MonadCatchIOTransformers, mtl, mwcRandom
, pwstoreFast, snapCore, snapServer, stm, syb, text, time
, transformers, unorderedContainers, utf8String, vector
, vectorAlgorithms, xmlhtml
}:

cabal.mkDerivation (self: {
  pname = "snap";
  version = "0.9.2.1";
  sha256 = "0gxnkr6icx2g16w3ab54cqy4x15xj6y9cs6qv8dg0xamm7kyyfhl";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    aeson attoparsec cereal clientsession configurator dataLens
    dataLensTemplate directoryTree filepath hashable heist logict
    MonadCatchIOTransformers mtl mwcRandom pwstoreFast snapCore
    snapServer stm syb text time transformers unorderedContainers
    utf8String vector vectorAlgorithms xmlhtml
  ];
  jailbreak = true;
  meta = {
    homepage = "http://snapframework.com/";
    description = "Top-level package for the Snap Web Framework";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
