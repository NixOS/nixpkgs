{ lib, fetchzip, buildDunePackage, ocaml
, cppo, ppx_derivers, ppxlib, ocaml-migrate-parsetree, result
, ounit
}:

let
  param =
    if lib.versionAtLeast ocaml.version "4.05"
    then {
      version = "5.1";
      sha256 = "0as0hy606vsbc4bf72vh2v23vdfaqlay22mlw6wbkr5b2l6w5b4w";
    } else {
      version = "5.0";
      sha256 = "0ihw9d75ic82knv1cvc38fr0wki7vrkavaja362ra9cqbwr1y0al";
    };
in

buildDunePackage rec {
  pname = "ppx_deriving";
  inherit (param) version;

  useDune2 = true;

  minimumOCamlVersion = "4.04";

  src = fetchzip {
    url = "https://github.com/ocaml-ppx/ppx_deriving/archive/v${param.version}.tar.gz";
    inherit (param) sha256;
  };

  buildInputs = [ cppo ];
  propagatedBuildInputs = [ ppxlib ocaml-migrate-parsetree ppx_derivers result ];

  doCheck = true;
  checkInputs = [ ounit ];

  meta = with lib; {
    description = "deriving is a library simplifying type-driven code generation on OCaml >=4.02.";
    maintainers = [ maintainers.maurer ];
    license = licenses.mit;
  };
}
