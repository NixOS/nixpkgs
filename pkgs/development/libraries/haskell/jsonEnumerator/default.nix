{ cabal, blazeBuilder, blazeBuilderEnumerator, enumerator
, jsonTypes, text, transformers
}:

cabal.mkDerivation (self: {
  pname = "json-enumerator";
  version = "0.0.1.2";
  sha256 = "08gwrm15pvvhhrkrncy6wr4fi5v55fdhc8byfrw5zd62hmx8xm9d";
  buildDepends = [
    blazeBuilder blazeBuilderEnumerator enumerator jsonTypes text
    transformers
  ];
  meta = {
    homepage = "http://github.com/snoyberg/json-enumerator";
    description = "Pure-Haskell utilities for dealing with JSON with the enumerator package. (deprecated)";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
