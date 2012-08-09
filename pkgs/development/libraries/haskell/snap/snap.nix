{ cabal, aeson, attoparsec, cereal, clientsession, configurator
, dataLens, dataLensTemplate, directoryTree, filepath, hashable
, heist, logict, MonadCatchIOTransformers, mtl, mwcRandom
, pwstoreFast, snapCore, snapServer, stm, syb, text, time
, transformers, unorderedContainers, utf8String, vector
, vectorAlgorithms, xmlhtml
}:

cabal.mkDerivation (self: {
  pname = "snap";
  version = "0.9.1.1";
  sha256 = "1g8jvnwrhna5g064dmv4v4khrpwwn0vcqw8l7rcpkp75l46fq29z";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    aeson attoparsec cereal clientsession configurator dataLens
    dataLensTemplate directoryTree filepath hashable heist logict
    MonadCatchIOTransformers mtl mwcRandom pwstoreFast snapCore
    snapServer stm syb text time transformers unorderedContainers
    utf8String vector vectorAlgorithms xmlhtml
  ];
  patchPhase = ''
    sed -i snap.cabal -e 's|clientsession.*,|clientsession,|'
  '';
  meta = {
    homepage = "http://snapframework.com/";
    description = "Snap: A Haskell Web Framework: project starter executable and glue code library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
