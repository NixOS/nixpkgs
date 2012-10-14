{ cabal, aeson, attoparsec, cereal, clientsession, configurator
, dataLens, dataLensTemplate, directoryTree, filepath, hashable
, heist, logict, MonadCatchIOTransformers, mtl, mwcRandom
, pwstoreFast, snapCore, snapServer, stm, syb, text, time
, transformers, unorderedContainers, vector, vectorAlgorithms
, xmlhtml
}:

cabal.mkDerivation (self: {
  pname = "snap";
  version = "0.9.2.2";
  sha256 = "1ql9c8b9arcd8zwlwsiipl4diah87sp339ljc5bc7yls1g4d9zsw";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    aeson attoparsec cereal clientsession configurator dataLens
    dataLensTemplate directoryTree filepath hashable heist logict
    MonadCatchIOTransformers mtl mwcRandom pwstoreFast snapCore
    snapServer stm syb text time transformers unorderedContainers
    vector vectorAlgorithms xmlhtml
  ];
  meta = {
    homepage = "http://snapframework.com/";
    description = "Top-level package for the Snap Web Framework";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
