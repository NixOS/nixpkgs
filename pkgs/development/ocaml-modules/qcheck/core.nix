{ lib, buildDunePackage, fetchFromGitHub }:

buildDunePackage rec {
  pname = "qcheck-core";
  version = "0.20";

  minimalOCamlVersion = "4.08";
  duneVersion = "3";

  src = fetchFromGitHub {
    owner = "c-cube";
    repo = "qcheck";
    rev = "v${version}";
    sha256 = "sha256-d3gleiaPEDJTbHtieL4oAq1NlA/0NtzdW9SA1sItFeQ=";
  };

  patches = [ ./bytes.patch ];

  meta = {
    description = "Core qcheck library";
    homepage = "https://c-cube.github.io/qcheck/";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.vbgl ];
  };

}
