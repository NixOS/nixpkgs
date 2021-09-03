{ lib, fetchFromGitHub, buildDunePackage, cmdliner, ppxlib }:

buildDunePackage rec {
  pname = "bisect_ppx";
  version = "2.6.1";

  src = fetchFromGitHub {
    owner = "aantron";
    repo = "bisect_ppx";
    rev = version;
    sha256 = "sha256-YeLDlH3mUbVEY4OmzlrvSwVUav3uMtSsTFlOsQKnz84=";
  };

  minimumOCamlVersion = "4.08";
  useDune2 = true;

  buildInputs = [
    cmdliner
    ppxlib
  ];

  meta = with lib; {
    description = "Bisect_ppx is a code coverage tool for OCaml and Reason. It helps you test thoroughly by showing what's not tested.";
    license = licenses.mit;
    homepage = "https://github.com/aantron/bisect_ppx";
    maintainers = with maintainers; [ ];
  };
}
