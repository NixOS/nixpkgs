{ cabal, aeson, attoparsec, conduit, text, transformers
, unorderedContainers, vector
}:

cabal.mkDerivation (self: {
  pname = "yaml";
  version = "0.5.1.2";
  sha256 = "0xmx58h47prpmgbf63bsy7ar74h0d968wyd2yg3bgvwmnd83iz7d";
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
