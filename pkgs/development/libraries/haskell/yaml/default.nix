{ cabal, aeson, attoparsec, conduit, hspec, HUnit, resourcet
, scientific, text, transformers, unorderedContainers, vector
}:

cabal.mkDerivation (self: {
  pname = "yaml";
  version = "0.8.5.4";
  sha256 = "0mn1i0whqr9q6vh43x5xa0p4xxckqszhsi62warx1kjvrq4yil6f";
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
