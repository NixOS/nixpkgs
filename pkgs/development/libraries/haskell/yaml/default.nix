{ cabal, aeson, attoparsec, conduit, hspec, HUnit, resourcet
, scientific, text, transformers, unorderedContainers, vector
}:

cabal.mkDerivation (self: {
  pname = "yaml";
  version = "0.8.6.2";
  sha256 = "1qgxjm6jv7w12a30irgb0dgdn51zxzcwqd0r713l26v35m2fvmdg";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    aeson attoparsec conduit resourcet scientific text transformers
    unorderedContainers vector
  ];
  testDepends = [
    aeson conduit hspec HUnit text transformers unorderedContainers
    vector
  ];
  meta = {
    homepage = "http://github.com/snoyberg/yaml/";
    description = "Support for parsing and rendering YAML documents";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
