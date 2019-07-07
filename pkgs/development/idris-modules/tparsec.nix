{ build-idris-package
, fetchFromGitHub
, lib
}:
build-idris-package  {
  name = "tparsec";
  version = "2019-06-18";

  ipkgName = "TParsec";

  src = fetchFromGitHub {
    owner = "gallais";
    repo = "idris-tparsec";
    rev = "3809afd8735b0054e5db788f18a7fa8ed71d8278";
    sha256 = "0wmgg1zg9p8gqlfvcsnww17jsifx9987cxqdq6kbdgasn26w2rqx";
  };

  meta = {
    description = "TParsec - Total Parser Combinators in Idris";
    homepage = https://github.com/gallais/idris-tparsec;
    license = lib.licenses.gpl3;
    maintainers = [ lib.maintainers.brainrape ];
  };
}
