{cabal, blazeBuilder, blazeBuilderEnumerator, enumerator, jsonTypes, text, transformers}:

cabal.mkDerivation (self : {
  pname = "json-enumerator";
  version = "0.0.1.1";
  sha256 = "0k94x9vwwaprqbc8gay5l0vg6hjmjpjp852yncncb8kr0r344z7l";
  propagatedBuildInputs =
    [blazeBuilder blazeBuilderEnumerator enumerator jsonTypes text transformers];
  meta = {
    description = "Provides the ability to render JSON in a streaming manner using the enumerator package";
    license = "BSD3";
  };
})
