{
  lib,
  buildDunePackage,
  fetchurl,
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
}:

buildDunePackage rec {
  pname = "phylogenetics";
  version = "0.3.0";

  src = fetchurl {
    url = "https://github.com/biocaml/phylogenetics/releases/download/v${version}/phylogenetics-${version}.tbz";
    hash = "sha256-3oZ9fMAXqOQ02rQ+8W8PZJWXOJLNe2qERrGOeTk3BKg=";
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
    printbox-text
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
