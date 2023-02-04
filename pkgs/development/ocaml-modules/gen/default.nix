{ lib, buildDunePackage, fetchFromGitHub, ocaml
, dune-configurator
, seq
, qcheck, ounit2
}:

buildDunePackage rec {
  version = "1.0";
  pname = "gen";
  minimalOCamlVersion = "4.03";

  src = fetchFromGitHub {
    owner = "c-cube";
    repo = "gen";
    rev = "v${version}";
    hash = "sha256-YWoVcl2TQoMIgU1LoKL16ia31zJjwAMwuphtSXnhtvw=";
  };

  buildInputs = [ dune-configurator ];
  propagatedBuildInputs = [ seq ];
  checkInputs = [ qcheck ounit2 ];

  doCheck = lib.versionAtLeast ocaml.version "4.08";

  meta = {
    homepage = "https://github.com/c-cube/gen";
    description = "Simple, efficient iterators for OCaml";
    license = lib.licenses.bsd3;
  };
}
