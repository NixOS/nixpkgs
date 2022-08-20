{ lib, fetchFromGitHub, buildDunePackage, cmdliner, ppxlib }:

buildDunePackage rec {
  pname = "bisect_ppx";
  version = "2.8.1";

  src = fetchFromGitHub {
    owner = "aantron";
    repo = "bisect_ppx";
    rev = version;
    sha256 = "sha256-pOeeSxzUF1jXQjA71atSZALdgQ2NB9qpKo5iaDnPwhQ=";
  };

  minimumOCamlVersion = "4.08";
  useDune2 = true;

  buildInputs = [
    cmdliner
    ppxlib
  ];

  meta = with lib; {
    description = "Bisect_ppx is a code coverage tool for OCaml and Reason. It helps you test thoroughly by showing what's not tested.";
    homepage = "https://github.com/aantron/bisect_ppx";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    mainProgram = "bisect-ppx-report";
  };
}
