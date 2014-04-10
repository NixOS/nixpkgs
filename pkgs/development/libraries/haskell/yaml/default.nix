{ cabal, aeson, attoparsec, conduit, hspec, HUnit, resourcet
, scientific, text, transformers, unorderedContainers, vector
}:

cabal.mkDerivation (self: {
  pname = "yaml";
  version = "0.8.8.1";
  sha256 = "1lkw05rx88jckzlkslb945zswn6g7i3vxsgxpj9pkcxvh3y9zagv";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    aeson attoparsec conduit resourcet scientific text transformers
    unorderedContainers vector
  ];
  testDepends = [
    aeson conduit hspec HUnit resourcet text transformers
    unorderedContainers vector
  ];
  meta = {
    homepage = "http://github.com/snoyberg/yaml/";
    description = "Support for parsing and rendering YAML documents";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
