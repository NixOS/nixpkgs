{
  lib,
  mkDerivation,
  fetchFromGitHub,
  standard-library,
}:

mkDerivation {
  pname = "agdarsec";
  version = "0.5.0-unstable-2025-08-05";

  src = fetchFromGitHub {
    owner = "gallais";
    repo = "agdarsec";
    rev = "28c5233e905474f3b02cb97fe410beb60364ba80";
    sha256 = "sha256-IMxRqZQ7XtPT2cDkoP5mBAj2ovMf5cHcN4U4V5FMEaQ=";
  };

  postPatch = ''
    sed -Ei 's/standard-library-[0-9.]+/standard-library/' agdarsec.agda-lib
  '';

  buildInputs = [ standard-library ];

  meta = with lib; {
    homepage = "https://gallais.github.io/agdarsec/";
    description = "Total Parser Combinators in Agda";
    license = licenses.gpl3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ turion ];
  };
}
