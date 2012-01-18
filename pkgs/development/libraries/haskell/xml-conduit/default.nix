{ cabal, attoparsec, attoparsecConduit, blazeBuilder
, blazeBuilderConduit, conduit, dataDefault, failure
, systemFilepath, text, transformers, xmlTypes
}:

cabal.mkDerivation (self: {
  pname = "xml-conduit";
  version = "0.5.1.1";
  sha256 = "0md6fkjn8j1dsbhlwh64x2990kvsmks6plppa63v9nwc9142ajim";
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
