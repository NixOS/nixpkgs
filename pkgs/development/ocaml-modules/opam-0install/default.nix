{ lib, fetchFromGitHub, buildDunePackage
, fmt, cmdliner, opam-state, opam-file-format
, astring, alcotest, opam-client, opam-solver
, ... ## 0install-solver
}@inputs:

buildDunePackage rec {
  pname = "opam-0install";
  version = "0.4.3";

  duneVersion = "3";

  src = fetchFromGitHub {
    owner = "ocaml-opam";
    repo = "opam-0install-solver";
    rev = "v${version}";
    sha256 = "sha256-ExF5R2lu5vKJ7uoIn/O8/CMEPuUTOSV4LDA/3W7AKJE=";
  };

  propagatedBuildInputs = [
    inputs."0install-solver"
    cmdliner
    fmt
    opam-file-format
    opam-state
  ];

  doCheck = true;
  checkInputs = [
    astring
    alcotest
    opam-client
    opam-solver
  ];

  meta = {
    description = "Opam solver using 0install backend";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.niols ];
    homepage = "https://github.com/ocaml-opam/opam-0install-solver";
  };
}
