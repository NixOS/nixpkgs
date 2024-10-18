{ mkDerivation, base, base16-bytestring, bytestring, directory
, fetchgit, HUnit, lib, temporary, text
}:
mkDerivation {
  pname = "direct-sqlcipher";
  version = "2.3.28";
  src = fetchgit {
    url = "https://github.com/simplex-chat/direct-sqlcipher";
    sha256 = "sha256-reCGBu1eVZU3h0gFduoHcQRBEH99Pm8PVmtyN4kbgeI=";
    rev = "f814ee68b16a9447fbb467ccc8f29bdd3546bfd9";
    fetchSubmodules = true;
  };
  libraryHaskellDepends = [ base bytestring text ];
  testHaskellDepends = [
    base base16-bytestring bytestring directory HUnit temporary text
  ];
  homepage = "https://github.com/simplex-chat/direct-sqlcipher";
  description = "Low-level binding to SQLCipher. Includes UTF8 and BLOB support.";
  license = lib.licenses.bsd3;
}
