{ cabal, aeson, attoparsec, cereal, clientsession, comonad
, configurator, directoryTree, dlist, errors, filepath, hashable
, heist, lens, logict, MonadCatchIOTransformers, mtl, mwcRandom
, pwstoreFast, regexPosix, snapCore, snapServer, stm, syb, text
, time, transformers, unorderedContainers, vector, vectorAlgorithms
, xmlhtml
}:

cabal.mkDerivation (self: {
  pname = "snap";
  version = "0.13.2.8";
  sha256 = "1jrnh1raw2jrl04l54f5w5xfp9yyb9bj0ly9v1baqkiggswacbzg";
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
  patchPhase = ''
    sed -i -e 's|lens .*< 4.2|lens|' snap.cabal
  '';
  meta = {
    homepage = "http://snapframework.com/";
    description = "Top-level package for the Snap Web Framework";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
