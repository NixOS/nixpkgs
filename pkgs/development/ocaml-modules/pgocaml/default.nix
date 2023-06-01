{ lib, fetchFromGitHub, buildDunePackage
, calendar, csv, hex, ppx_deriving, ppx_sexp_conv, re, rresult, sexplib
}:

buildDunePackage rec {
  pname = "pgocaml";
  version = "4.3.0";
  src = fetchFromGitHub {
    owner = "darioteixeira";
    repo = "pgocaml";
    rev = version;
    hash = "sha256-W1fbRnU1l61qqxfVY2qiBnVpGD81xrBO8k0tWr+RXMY=";
  };

  minimalOCamlVersion = "4.08";
  duneVersion = "3";

  propagatedBuildInputs = [ calendar csv hex ppx_deriving ppx_sexp_conv re rresult sexplib ];

  meta = with lib; {
    description = "An interface to PostgreSQL databases for OCaml applications";
    inherit (src.meta) homepage;
    license = licenses.lgpl2;
    maintainers = with maintainers; [ vbgl ];
  };
}
