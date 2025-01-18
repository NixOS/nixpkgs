{
  build-idris-package,
  fetchFromGitHub,
  contrib,
  lib,
}:
build-idris-package {
  pname = "tparsec";
  version = "2020-02-11";

  ipkgName = "TParsec";

  idrisDeps = [ contrib ];

  src = fetchFromGitHub {
    owner = "gallais";
    repo = "idris-tparsec";
    rev = "943c64dfcb4e1582696f68312fad88145dc3a8e4";
    sha256 = "0pyhkafhx2pwim91ada6qrgacvahl9bpv5m486y8fph4qzf4z6mx";
  };

  meta = with lib; {
    description = "TParsec - Total Parser Combinators in Idris";
    homepage = "https://github.com/gallais/idris-tparsec";
    license = licenses.gpl3;
    maintainers = [ maintainers.brainrape ];
  };
}
