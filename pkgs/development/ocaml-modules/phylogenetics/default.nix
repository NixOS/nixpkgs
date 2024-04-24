{ lib
, ocaml
, buildDunePackage
, fetchFromGitHub
, ppx_deriving
, bppsuite
, alcotest
, angstrom-unix
, biocaml
, core
, gsl
, lacaml
, menhir
, menhirLib
, printbox-text
}:

lib.throwIf (lib.versionAtLeast ocaml.version "5.0")
  "phylogenetics is not compatible with OCaml ${ocaml.version}"

buildDunePackage rec {
  pname = "phylogenetics";
  version = "unstable-2022-05-06";

  src = fetchFromGitHub {
    owner = "biocaml";
    repo = pname;
    rev = "cd7c624d0f98e31b02933ca4511b9809b26d35b5";
    sha256 = "sha256:0w0xyah3hj05hxg1rsa40hhma3dm1cyq0zvnjrihhf22laxap7ga";
  };

  minimalOCamlVersion = "4.08";

  nativeCheckInputs = [ bppsuite ];
  checkInputs = [ alcotest ];
  nativeBuildInputs = [ menhir ];
  propagatedBuildInputs = [
    angstrom-unix
    biocaml
    core
    gsl
    lacaml
    menhirLib
    ppx_deriving
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
