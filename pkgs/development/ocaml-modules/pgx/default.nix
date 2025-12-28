{
  alcotest,
  buildDunePackage,
  camlp-streams,
  fetchFromGitHub,
  hex,
  ipaddr,
  lib,
  ppx_compare,
  ppx_custom_printf,
  ppx_sexp_conv,
  re,
  uuidm,
}:

buildDunePackage (finalAttrs: {
  pname = "pgx";
  version = "2.3";
  minimalOCamlVersion = "4.08";
  src = fetchFromGitHub {
    owner = "pgx-ocaml";
    repo = "pgx";
    tag = finalAttrs.version;
    hash = "sha256-SLRuSgJp19vlQ6h9AVqVI1S1w7tnbxEMnzI43leIQvU=";
  };
  propagatedBuildInputs = [
    camlp-streams
    hex
    ipaddr
    ppx_compare
    ppx_custom_printf
    ppx_sexp_conv
    re
    uuidm
  ];
  checkInputs = [ alcotest ];
  doCheck = true;
  meta = {
    inherit (finalAttrs.src.meta) homepage;
    description = "Pure-OCaml PostgreSQL client library";
    license = lib.licenses.lgpl2Only;
    maintainers = [ lib.maintainers.vog ];
  };
})
