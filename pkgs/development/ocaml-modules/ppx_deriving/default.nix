{ lib, fetchzip, buildDunePackage
, cppo, ppxfind, ppx_tools, ppx_derivers, result, ounit, ocaml-migrate-parsetree
}:

buildDunePackage rec {
  pname = "ppx_deriving";
  version = "4.5";

  src = fetchzip {
    url = "https://github.com/ocaml-ppx/ppx_deriving/archive/v${version}.tar.gz";
    sha256 = "1v2xldag54n0xk69vv3j4nln9bzkkpq3rildq118sydzsc9v239z";
  };

  buildInputs = [ ppxfind cppo ounit ];
  propagatedBuildInputs = [ ocaml-migrate-parsetree ppx_derivers ppx_tools result ];

  doCheck = true;

  meta = with lib; {
    description = "deriving is a library simplifying type-driven code generation on OCaml >=4.02.";
    maintainers = [ maintainers.maurer ];
    license = licenses.mit;
  };
}
