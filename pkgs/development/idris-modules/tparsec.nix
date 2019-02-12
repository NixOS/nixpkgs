{ build-idris-package
, fetchFromGitHub
, lib
}:
build-idris-package  {
  name = "tparsec";
  version = "2018-12-21";

  ipkgName = "TParsec";

  src = fetchFromGitHub {
    owner = "gallais";
    repo = "idris-tparsec";
    rev = "6fafcaa894def6f2af86bc799e507013b56e7741";
    sha256 = "0alnw0hqjs200gvb5f58lb16rna48j1v6wnvq4q7zbw99dcxsxwn";
  };

  meta = {
    description = "TParsec - Total Parser Combinators in Idris";
    homepage = https://github.com/gallais/idris-tparsec;
    license = lib.licenses.gpl3;
    maintainers = [ lib.maintainers.brainrape ];
  };
}
