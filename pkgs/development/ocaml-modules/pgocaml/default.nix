{ lib, fetchFromGitHub, buildDunePackage
, calendar, csv, hex, ppx_deriving, ppx_sexp_conv, re, rresult, sexplib
}:

buildDunePackage rec {
  pname = "pgocaml";
  version = "4.2.2";
  src = fetchFromGitHub {
    owner = "darioteixeira";
    repo = "pgocaml";
    rev = version;
    sha256 = "1rdypc83nap9j2ml9r6n1pzgf79gk1yffwyi6fmcrl7zmy01cg0n";
  };

  minimumOCamlVersion = "4.07";
  useDune2 = true;

  propagatedBuildInputs = [ calendar csv hex ppx_deriving ppx_sexp_conv re rresult sexplib ];

  meta = with lib; {
    description = "An interface to PostgreSQL databases for OCaml applications";
    inherit (src.meta) homepage;
    license = licenses.lgpl2;
    maintainers = with maintainers; [ vbgl ];
  };
}
