{ cabal, aeson, attoparsec, conduit, text, transformers
, unorderedContainers, vector
}:

cabal.mkDerivation (self: {
  pname = "yaml";
  version = "0.5.2";
  sha256 = "1jhzycasfmjlfdpca1cflrggc16jp16852af7d6cwfsy342wh6gp";
  buildDepends = [
    aeson attoparsec conduit text transformers unorderedContainers
    vector
  ];
  meta = {
    homepage = "http://github.com/snoyberg/yaml/";
    description = "Low-level binding to the libyaml C library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
