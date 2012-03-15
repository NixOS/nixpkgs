{ cabal, attoparsec, attoparsecConduit, blazeBuilder
, blazeBuilderConduit, conduit, dataDefault, failure, monadControl
, systemFilepath, text, transformers, xmlTypes
}:

cabal.mkDerivation (self: {
  pname = "xml-conduit";
  version = "0.5.4";
  sha256 = "1apvh2xlh4wkrfak0yqycsadsnkybfwjb86zqalm8ni9w2p9lwr6";
  buildDepends = [
    attoparsec attoparsecConduit blazeBuilder blazeBuilderConduit
    conduit dataDefault failure monadControl systemFilepath text
    transformers xmlTypes
  ];
  meta = {
    homepage = "http://github.com/snoyberg/xml";
    description = "Pure-Haskell utilities for dealing with XML with the conduit package";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
