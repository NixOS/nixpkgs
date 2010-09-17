{cabal, HStringTemplate, csv, pandoc, parsec, split, utf8String, xhtml, HsSyck, time}:

cabal.mkDerivation (self : {
  pname = "yst";
  version = "0.2.3.2";
  sha256 = "b857e70db67d708e2edb61a1d6bc4eaff3abd2bc252b3605f66bf1760da4da4b";
  propagatedBuildInputs = [
    HStringTemplate csv pandoc parsec split utf8String xhtml HsSyck time
  ];
  meta = {
    description =
      "Builds a static website from templates and data in YAML or CSV files";
  };
})
