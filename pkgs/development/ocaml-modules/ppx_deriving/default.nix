{ lib, fetchzip, buildDunePackage
, cppo, ppx_derivers, ppxlib, ocaml-migrate-parsetree, result
, ounit
}:

buildDunePackage rec {
  pname = "ppx_deriving";
  version = "5.1";

  useDune2 = true;

  minimumOCamlVersion = "4.05";

  src = fetchzip {
    url = "https://github.com/ocaml-ppx/ppx_deriving/archive/v${version}.tar.gz";
    sha256 = "0as0hy606vsbc4bf72vh2v23vdfaqlay22mlw6wbkr5b2l6w5b4w";
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
