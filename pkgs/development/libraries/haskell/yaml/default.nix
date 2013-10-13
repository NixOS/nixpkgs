{ cabal, aeson, attoparsec, conduit, hspec, HUnit, resourcet, text
, transformers, unorderedContainers, vector
}:

cabal.mkDerivation (self: {
  pname = "yaml";
  version = "0.8.5.1";
  sha256 = "0vbampykc5a027q5fh5w6i1bxblyxx7s3nzhpzaa4c1yz8nz3k57";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    aeson attoparsec conduit resourcet text transformers
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
