{ build-idris-package
, fetchFromGitHub
, prelude
, lib
, idris
}:

build-idris-package  {
  name = "tparsec";
  version = "2017-12-12";

  idrisDeps = [ prelude ];

  src = fetchFromGitHub {
    owner = "gallais";
    repo = "idris-tparsec";
    rev = "fb87d08f8f58c934f37d8324b43b0979abcf2183";
    sha256 = "0362076bfs976gqki4b4pxblhnk4xglgx5v2aycjpxsxlpxh6cfd";
  };

  meta = {
    description = "TParsec - Total Parser Combinators in Idris";
    homepage = https://github.com/gallais/idris-tparsec;
    license = lib.licenses.gpl3;
    maintainers = [ lib.maintainers.brainrape ];
    inherit (idris.meta) platforms;
  };
}
