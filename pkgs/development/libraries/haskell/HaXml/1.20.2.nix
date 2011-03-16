{cabal, polyparse}:

cabal.mkDerivation (self : {
  pname = "HaXml";
  version = "1.20.2";
  sha256 = "05kmr2ablinnrg3x1xr19g5kzzby322lblvcvhwbkv26ajwi0b63";
  propagatedBuildInputs = [polyparse];
  meta = {
    description = "Haskell utilities for parsing, filtering, transforming and generating XML documents.";
  };
})

