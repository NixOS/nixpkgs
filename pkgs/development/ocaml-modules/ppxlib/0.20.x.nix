{ lib, fetchFromGitHub, buildDunePackage, ocaml
, ocaml-compiler-libs, ocaml-migrate-parsetree, ppx_derivers, sexplib0, stdlib-shims
, stdio, base, cinaps
}:

buildDunePackage rec {
  pname = "ppxlib";
  version = "0.20.0";

  minimumOCamlVersion = "4.04.1";

  useDune2 = true;

  src = fetchFromGitHub {
    owner = "ocaml-ppx";
    repo = pname;
    rev = version;
    sha256 = "0nwwvh58hf18wpfh6i5mgsykiaw0rj9vy5id4xmja36s3pm5bcn3";
  };

  propagatedBuildInputs = [
    ocaml-compiler-libs ocaml-migrate-parsetree ppx_derivers sexplib0 stdlib-shims
  ];

  doCheck = lib.versionAtLeast ocaml.version "4.10";
  checkInputs = [
    stdio base cinaps
  ];

  meta = {
    description = "Comprehensive ppx tool set";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.vbgl ];
    inherit (src.meta) homepage;
  };
}
