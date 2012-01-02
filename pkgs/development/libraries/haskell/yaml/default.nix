{ cabal, aeson, attoparsec, conduit, text, transformers
, unorderedContainers, vector
}:

cabal.mkDerivation (self: {
  pname = "yaml";
  version = "0.5.1.1";
  sha256 = "1l3f1rbdajdf9944kwbf90a1wxv00g2jcgjkg54k6c3iqbx956w2";
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
