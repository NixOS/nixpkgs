{cabal, utilityHt, transformers}:

cabal.mkDerivation (self : {
  pname = "storable-record";
  version = "0.0.2.4";
  sha256 = "5ed2680dcfc4c3d4fe605d23e797b847fe047b7acd3f4acfd82155c93e72b280";
  propagatedBuildInputs = [utilityHt transformers];
  meta = {
    description = "build a Storable instance of a record type from Storable instances of its elements";
  };
})

