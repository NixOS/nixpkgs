{ lib, fetchFromGitHub, buildDunePackage, cmdliner, ocaml-migrate-parsetree, ppx_tools_versioned }:

buildDunePackage rec {
  pname = "bisect_ppx";
  version = "2.5.0";

  useDune2 = true;

  src = fetchFromGitHub {
    owner = "aantron";
    repo = "bisect_ppx";
    rev = version;
    sha256 = "0w2qd1myvh333jvkf8hgrqzl8ns4xgfggk4frf1ij3jyc7qc0868";
  };

  buildInputs = [
    cmdliner
    ocaml-migrate-parsetree
    ppx_tools_versioned
  ];

  meta = {
    description = "Code coverage for OCaml";
    license = lib.licenses.mit;
    homepage = "https://github.com/aantron/bisect_ppx";
  };
}
