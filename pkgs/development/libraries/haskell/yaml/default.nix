{ cabal, aeson, attoparsec, conduit, hspec, HUnit, resourcet
, scientific, text, transformers, unorderedContainers, vector
}:

cabal.mkDerivation (self: {
  pname = "yaml";
  version = "0.8.6";
  sha256 = "0qmbgb2gsqj25hl1blxjjcpk5fp5za9d1vshjs86mpapqvlhr9rn";
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
