{cabal, HUnit, mtl, parsec, regexpr, safe, split, utf8String}:

cabal.mkDerivation (self : {
  pname = "hledger-lib";
  version = "0.14";
  sha256 = "9a6d6ab4383800279e135e9bbcd886e95cea45232d093202c5d43e6edd1f927c";
  propagatedBuildInputs = [HUnit mtl parsec regexpr safe split utf8String];
  meta = {
    description = "core data types, parsers and utilities used by the hledger tools";
  };
})
