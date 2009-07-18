{cabal, binary, network}:

cabal.mkDerivation (self : {
  pname = "hspread";
  version = "0.3.3";
  sha256 = "6e8a9ecc1a6b1cc767aa188e2f4c04b77b321fd14000cac8f71dd6a7b82afbfc";
  propagatedBuildInputs = [binary network];
  meta = {
    description = "A client library for the spread toolkit";
  };
})
