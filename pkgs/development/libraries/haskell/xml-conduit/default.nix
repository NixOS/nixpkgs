{ cabal, attoparsec, attoparsecConduit, blazeBuilder
, blazeBuilderConduit, conduit, dataDefault, failure
, systemFilepath, text, transformers, xmlTypes
}:

cabal.mkDerivation (self: {
  pname = "xml-conduit";
  version = "0.5.3";
  sha256 = "09jphn19g6v9z1b75iyqcdyn75n7inbhib8g9fgfzwd7q8rdd3yc";
  buildDepends = [
    attoparsec attoparsecConduit blazeBuilder blazeBuilderConduit
    conduit dataDefault failure systemFilepath text transformers
    xmlTypes
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
