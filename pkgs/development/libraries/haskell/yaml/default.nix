{ cabal, aeson, attoparsec, conduit, hspec, HUnit, resourcet, text
, transformers, unorderedContainers, vector
}:

cabal.mkDerivation (self: {
  pname = "yaml";
  version = "0.8.2.3";
  sha256 = "1ds6969gbkxgkm2fha0ifmssjl7by9glgix165v0h8i7fx9wx3wa";
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
