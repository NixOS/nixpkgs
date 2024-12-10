{
  lib,
  buildDunePackage,
  fetchurl,
  ppx_deriving,
  bppsuite,
  alcotest,
  angstrom-unix,
  biotk,
  core,
  gsl,
  lacaml,
  menhir,
  menhirLib,
  printbox-text,
  yojson,
}:

buildDunePackage rec {
  pname = "phylogenetics";
  version = "0.2.0";

  src = fetchurl {
    url = "https://github.com/biocaml/phylogenetics/releases/download/v${version}/phylogenetics-${version}.tbz";
    hash = "sha256-JFpYp3pyW7PrBjqCwwDZxkJPA84dp6Qs8rOPvHPY92o=";
  };

  minimalOCamlVersion = "4.08";

  nativeCheckInputs = [ bppsuite ];
  checkInputs = [ alcotest ];
  nativeBuildInputs = [ menhir ];
  propagatedBuildInputs = [
    angstrom-unix
    biotk
    core
    gsl
    lacaml
    menhirLib
    ppx_deriving
    printbox-text
    yojson
  ];

  checkPhase = ''
    runHook preCheck
    dune build @app/fulltest
    runHook postCheck
  '';
  doCheck = true;

  meta = with lib; {
    description = "Algorithms and datastructures for phylogenetics";
    homepage = "https://github.com/biocaml/phylogenetics";
    license = licenses.cecill-b;
    maintainers = [ maintainers.bcdarwin ];
    mainProgram = "phylosim";
  };
}
