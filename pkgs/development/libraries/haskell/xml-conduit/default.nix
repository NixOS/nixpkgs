{ cabal, attoparsec, attoparsecConduit, blazeBuilder
, blazeBuilderConduit, conduit, dataDefault, failure
, systemFilepath, text, transformers, xmlTypes
}:

cabal.mkDerivation (self: {
  pname = "xml-conduit";
  version = "0.5.0.1";
  sha256 = "0n30mk3dmdwxjw4vgfmlj7dzbiah9vj4hlg258qkvy5likzz1j5n";
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
