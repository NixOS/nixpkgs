{ lib, buildDunePackage, fetchFromGitHub }:

buildDunePackage rec {
  pname = "qcheck-core";
  version = "0.21.2";

  minimalOCamlVersion = "4.08";

  src = fetchFromGitHub {
    owner = "c-cube";
    repo = "qcheck";
    rev = "v${version}";
    hash = "sha256-a+sjpvpQZbXjQgyx69hhVAmRCfDMMhFlg965dK5UN6Q=";
  };

  patches = [ ./bytes.patch ];

  meta = {
    description = "Core qcheck library";
    homepage = "https://c-cube.github.io/qcheck/";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.vbgl ];
  };

}
