{ mkDerivation, attoparsec, base, base16-bytestring, blaze-builder
, blaze-textual, bytestring, containers, direct-sqlcipher
, exceptions, fetchgit, HUnit, lib, Only, template-haskell, text
, time, transformers
}:
mkDerivation {
  pname = "sqlcipher-simple";
  version = "0.4.18.1";
  src = fetchgit {
    url = "https://github.com/simplex-chat/sqlcipher-simple";
    sha256 = "sha256-9JV2odagCkUWUGEe8dWmqHfjcBmn6rf6FAEBhxo6Gfw=";
    rev = "a46bd361a19376c5211f1058908fc0ae6bf42446";
    fetchSubmodules = true;
  };
  libraryHaskellDepends = [
    attoparsec base blaze-builder blaze-textual bytestring containers
    direct-sqlcipher exceptions Only template-haskell text time
    transformers
  ];
  testHaskellDepends = [
    base base16-bytestring bytestring direct-sqlcipher HUnit text time
  ];
  homepage = "https://github.com/simplex-chat/sqlcipher-simple";
  description = "Mid-Level SQLite client library";
  license = lib.licenses.bsd3;
}
