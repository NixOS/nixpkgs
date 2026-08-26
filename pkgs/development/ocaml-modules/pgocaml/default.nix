{
  lib,
  fetchFromGitHub,
  buildDunePackage,
  calendar,
  camlp-streams,
  csv,
  hex,
  ppx_deriving,
  ppx_sexp_conv,
  re,
  rresult,
  sexplib,
}:

buildDunePackage (finalAttrs: {
  pname = "pgocaml";
  version = "4.4.0";
  src = fetchFromGitHub {
    owner = "darioteixeira";
    repo = "pgocaml";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Mz3zVgXas1UivH/BVARx5kWClgr9v9YcGarwaD961tU=";
  };

  minimalOCamlVersion = "4.08";

  propagatedBuildInputs = [
    calendar
    csv
    hex
    ppx_deriving
    ppx_sexp_conv
    re
    rresult
    sexplib
    camlp-streams
  ];

  meta = {
    description = "Interface to PostgreSQL databases for OCaml applications";
    homepage = "https://github.com/darioteixeira/pgocaml";
    license = lib.licenses.lgpl2Only;
    maintainers = with lib.maintainers; [ vbgl ];
  };
})
