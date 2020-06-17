{ lib, fetchzip, buildDunePackage
, cppo, ppxfind, ppx_tools, ppx_derivers, result, ounit, ocaml-migrate-parsetree
}:

buildDunePackage rec {
  pname = "ppx_deriving";
  version = "4.4.1";

  src = fetchzip {
    url = "https://github.com/ocaml-ppx/ppx_deriving/archive/v${version}.tar.gz";
    sha256 = "1map50w2a35y83bcd19p9yakdkhp04z5as2j2wlygi0b6s0a9vba";
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
