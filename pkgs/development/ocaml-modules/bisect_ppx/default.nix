{ lib, fetchFromGitHub, buildDunePackage, cmdliner, ppxlib }:

buildDunePackage rec {
  pname = "bisect_ppx";
  version = "2.8.3";

  src = fetchFromGitHub {
    owner = "aantron";
    repo = "bisect_ppx";
    rev = version;
    hash = "sha256-3qXobZLPivFDtls/3WNqDuAgWgO+tslJV47kjQPoi6o=";
  };

  minimalOCamlVersion = "4.11";

  buildInputs = [
    cmdliner
    ppxlib
  ];

  meta = with lib; {
    description = "Bisect_ppx is a code coverage tool for OCaml and Reason. It helps you test thoroughly by showing what's not tested";
    homepage = "https://github.com/aantron/bisect_ppx";
    license = licenses.mit;
    maintainers = [ ];
    mainProgram = "bisect-ppx-report";
  };
}
