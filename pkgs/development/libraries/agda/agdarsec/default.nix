{
  lib,
  mkDerivation,
  fetchFromGitHub,
  standard-library,
}:

mkDerivation rec {
  pname = "agdarsec";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "gallais";
    repo = "agdarsec";
    rev = "v${version}";
    sha256 = "02fqkycvicw6m2xsz8p01aq8n3gj2d2gyx8sgj15l46f8434fy0x";
  };

  everythingFile = "./index.agda";

  includePaths = [
    "src"
    "examples"
  ];

  buildInputs = [ standard-library ];

  meta = {
    homepage = "https://gallais.github.io/agdarsec/";
    description = "Total Parser Combinators in Agda";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ turion ];
    broken = true;
  };
}
