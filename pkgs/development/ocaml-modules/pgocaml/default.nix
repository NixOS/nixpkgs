{ lib, fetchFromGitHub, fetchpatch, buildDunePackage, ocaml
, calendar, camlp-streams, csv, hex, ppx_deriving, ppx_sexp_conv, re, rresult, sexplib
}:

let with-camlp-streams = lib.optional (lib.versionAtLeast ocaml.version "5.0"); in

buildDunePackage rec {
  pname = "pgocaml";
  version = "4.3.0";
  src = fetchFromGitHub {
    owner = "darioteixeira";
    repo = "pgocaml";
    rev = version;
    hash = "sha256-W1fbRnU1l61qqxfVY2qiBnVpGD81xrBO8k0tWr+RXMY=";
  };

  # Compatibility with OCaml ≥ 5.0
  patches = with-camlp-streams (fetchpatch {
    url = "https://github.com/darioteixeira/pgocaml/commit/906a289dc57da4971e312c31eedd26d81e902ed5.patch";
    hash = "sha256-/v9Jheg98GhrcD2gcsQpPvq7YiIrvJj22SKvrBRlR9Y=";
  });

  minimalOCamlVersion = "4.08";

  propagatedBuildInputs = [ calendar csv hex ppx_deriving ppx_sexp_conv re rresult sexplib ]
  ++ with-camlp-streams camlp-streams;

  meta = with lib; {
    description = "An interface to PostgreSQL databases for OCaml applications";
    inherit (src.meta) homepage;
    license = licenses.lgpl2;
    maintainers = with maintainers; [ vbgl ];
  };
}
