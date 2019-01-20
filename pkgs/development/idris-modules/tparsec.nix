{ build-idris-package
, fetchFromGitHub
, lib
}:
build-idris-package  {
  name = "tparsec";
  version = "2018-11-09";

  ipkgName = "TParsec";

  src = fetchFromGitHub {
    owner = "gallais";
    repo = "idris-tparsec";
    rev = "fc5bc1e0bf21a53ec854990ed799c4c73e304b06";
    sha256 = "0ladks6x1qhs884w4rsxnzpq8dpijyqfqbvhk55kq10xh6w1smrz";
  };

  meta = {
    description = "TParsec - Total Parser Combinators in Idris";
    homepage = https://github.com/gallais/idris-tparsec;
    license = lib.licenses.gpl3;
    maintainers = [ lib.maintainers.brainrape ];
  };
}
