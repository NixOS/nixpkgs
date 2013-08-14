{ cabal, aeson, attoparsec, conduit, hspec, HUnit, resourcet, text
, transformers, unorderedContainers, vector
}:

cabal.mkDerivation (self: {
  pname = "yaml";
  version = "0.8.4.1";
  sha256 = "0zbnyf5hp206ywqkdd7c1hsdbn4wxwk7p3rzn53m7rzxvfshlbbx";
  buildDepends = [
    aeson attoparsec conduit resourcet text transformers
    unorderedContainers vector
  ];
  testDepends = [
    conduit hspec HUnit text transformers unorderedContainers
  ];
  meta = {
    homepage = "http://github.com/snoyberg/yaml/";
    description = "Support for parsing and rendering YAML documents";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
