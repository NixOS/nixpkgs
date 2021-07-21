{ mkDerivation, base, fetchgit, inspection-testing, lib
, transformers
}:
mkDerivation {
  pname = "ap-normalize";
  version = "0.1.0.1";
  src = fetchgit {
    url = "https://gitlab.com/lysxia/ap-normalize.git";
    sha256 = "0xfr00dy5qiisiwkhbmmisbv3zmfak5i8fx3b9ymxswxwvvbhjnc";
    rev = "ed521b63f02f1fe7d4e4ec5f8c5de2d4f76ab017";
    fetchSubmodules = true;
  };
  libraryHaskellDepends = [ base ];
  testHaskellDepends = [ base inspection-testing transformers ];
  description = "Self-normalizing applicative expressions";
  license = lib.licenses.mit;
}
