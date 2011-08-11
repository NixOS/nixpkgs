{ cabal, blazeBuilder, blazeBuilderEnumerator, enumerator
, jsonTypes, text, transformers
}:

cabal.mkDerivation (self: {
  pname = "json-enumerator";
  version = "0.0.1.1";
  sha256 = "0k94x9vwwaprqbc8gay5l0vg6hjmjpjp852yncncb8kr0r344z7l";
  buildDepends = [
    blazeBuilder blazeBuilderEnumerator enumerator jsonTypes text
    transformers
  ];
  meta = {
    homepage = "http://github.com/snoyberg/json-enumerator";
    description = "Pure-Haskell utilities for dealing with JSON with the enumerator package";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
