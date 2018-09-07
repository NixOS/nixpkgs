{ build-idris-package
, fetchFromGitHub
, lib
}:
build-idris-package  {
  name = "tparsec";
  version = "2018-06-26";

  src = fetchFromGitHub {
    owner = "gallais";
    repo = "idris-tparsec";
    rev = "ca32d1a83f3de95f8979d48016e79d010f47b3c2";
    sha256 = "1zjzk8xjmyyx1qwrdwwg7yjzcgj5wkbwpx8a3wpbj5sv4b5s2r30";
  };

  meta = {
    description = "TParsec - Total Parser Combinators in Idris";
    homepage = https://github.com/gallais/idris-tparsec;
    license = lib.licenses.gpl3;
    maintainers = [ lib.maintainers.brainrape ];
  };
}
