{ lib, fetchurl, buildDunePackage
, cppo, ppxlib, ppx_derivers, result, ounit, ocaml-migrate-parsetree
}:

let params =
  if lib.versionAtLeast ppxlib.version "0.15"
  then {
    version = "5.1";
    sha256 = "1i64fd7qrfzbam5hfbl01r0sx4iihsahcwqj13smmrjlnwi3nkxh";
  } else {
    version = "5.0";
    sha256 = "0fkzrn4pdyvf1kl0nwvhqidq01pnq3ql8zk1jd56hb0cxaw851w3";
  }
; in

buildDunePackage rec {
  pname = "ppx_deriving";
  inherit (params) version;

  useDune2 = true;

  src = fetchurl {
    url = "https://github.com/ocaml-ppx/ppx_deriving/releases/download/v${version}/ppx_deriving-v${version}.tbz";
    inherit (params) sha256;
  };

  buildInputs = [ ppxlib cppo ];
  propagatedBuildInputs = [ ocaml-migrate-parsetree ppx_derivers result ];

  doCheck = true;
  checkInputs = [ ounit ];

  meta = with lib; {
    description = "deriving is a library simplifying type-driven code generation on OCaml >=4.02.";
    maintainers = [ maintainers.maurer ];
    license = licenses.mit;
  };
}
