{ lib, fetchFromGitHub, buildDunePackage
, calendar, csv, hex, ppx_deriving, ppx_sexp_conv, re, rresult, sexplib
}:

buildDunePackage rec {
  pname = "pgocaml";
  version = "4.2.2-dev-20210111";
  src = fetchFromGitHub {
    owner = "darioteixeira";
    repo = "pgocaml";
    rev = "1bb0025deeb3d14029afdcc69aaa7847026e243e";
    sha256 = "11inbjf87gclc2xmpq56ag4cm4467y9q9hjgbdn69fa1bman2zn2";
  };

  minimumOCamlVersion = "4.08";
  useDune2 = true;

  propagatedBuildInputs = [ calendar csv hex ppx_deriving ppx_sexp_conv re rresult sexplib ];

  meta = with lib; {
    description = "An interface to PostgreSQL databases for OCaml applications";
    inherit (src.meta) homepage;
    license = licenses.lgpl2;
    maintainers = with maintainers; [ vbgl ];
  };
}
