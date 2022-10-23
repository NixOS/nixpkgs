{ lib
, buildDunePackage
, fetchFromGitHub
, alcotest
, cmdliner
, ppx_deriving
, ppxlib
, gitUpdater
}:

buildDunePackage rec {
  pname = "ppx_deriving_cmdliner";
  version = "0.6.0";

  minimumOCamlVersion = "4.08";
  useDune2 = true;

  src = fetchFromGitHub {
    owner = "hammerlab";
    repo = "ppx_deriving_cmdliner";
    rev = "v${version}";
    sha256 = "19l32y2wv64d1c7fvln07dg3bkf7wf5inzjxlff7lbabskdbbras";
  };

  propagatedBuildInputs = [
    cmdliner
    ppx_deriving
    ppxlib
  ];

  doCheck = true;
  checkInputs = [
    alcotest
  ];

  passthru.updateScript = gitUpdater { rev-prefix = "v"; };

  meta = with lib; {
    description = "Ppx_deriving plugin for generating command line interfaces from types for OCaml";
    inherit (src.meta) homepage;
    license = licenses.asl20;
    maintainers = [ maintainers.romildo ];
  };
}
