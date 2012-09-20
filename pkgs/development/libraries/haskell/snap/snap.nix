{ cabal, aeson, attoparsec, cereal, clientsession, configurator
, dataLens, dataLensTemplate, directoryTree, filepath, hashable
, heist, logict, MonadCatchIOTransformers, mtl, mwcRandom
, pwstoreFast, snapCore, snapServer, stm, syb, text, time
, transformers, unorderedContainers, utf8String, vector
, vectorAlgorithms, xmlhtml
}:

cabal.mkDerivation (self: {
  pname = "snap";
  version = "0.9.2";
  sha256 = "12sqc6j6v57jll8pkgzj71f6s435rwhqxqzl78l3rk4qn6sc0gzi";
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
    description = "Top-level package for the Snap Web Framework";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
