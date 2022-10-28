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
  version = "0.6.1";

  minimalOCamlVersion = "4.08";

  src = fetchFromGitHub {
    owner = "hammerlab";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-/22KLQnxu3e2ZSca6ZLxTJDfv/rsmgCUkJnZC0RwRi8";
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
    homepage = "https://github.com/hammerlab/ppx_deriving_cmdliner";
    license = licenses.asl20;
    maintainers = [ maintainers.romildo ];
  };
}
