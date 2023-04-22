{ lib, buildDunePackage, fetchFromGitHub, ocaml
, seq
, qcheck, ounit2
}:

buildDunePackage rec {
  version = "1.1";
  pname = "gen";
  minimalOCamlVersion = "4.03";
  duneVersion = "3";

  src = fetchFromGitHub {
    owner = "c-cube";
    repo = "gen";
    rev = "v${version}";
    hash = "sha256-ZytPPGhmt/uANaSgkgsUBOwyQ9ka5H4J+5CnJpEdrNk=";
  };

  propagatedBuildInputs = [ seq ];
  checkInputs = [ qcheck ounit2 ];

  doCheck = lib.versionAtLeast ocaml.version "4.08";

  meta = {
    homepage = "https://github.com/c-cube/gen";
    description = "Simple, efficient iterators for OCaml";
    license = lib.licenses.bsd3;
  };
}
