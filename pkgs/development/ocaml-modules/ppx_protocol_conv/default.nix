{
  lib,
  buildDunePackage,
  fetchFromGitHub,
  ppxlib,
  ppx_expect,
  ppx_sexp_conv,
  sexplib,
  alcotest,
}:

buildDunePackage (finalAttrs: {
  pname = "ppx_protocol_conv";
  version = "5.2.3";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "andersfugmann";
    repo = "ppx_protocol_conv";
    tag = finalAttrs.version;
    hash = "sha256-G6zMgHioPUCh2i50cjQ6talN8CYO6UhEaWgi0xe3CWA=";
  };

  propagatedBuildInputs = [ ppxlib ];

  doCheck = true;
  checkInputs = [
    ppx_expect
    ppx_sexp_conv
    sexplib
    alcotest
  ];

  meta = {
    description = "Pluggable serialization and deserialization of ocaml data strucures based on type_conv";
    homepage = "https://github.com/andersfugmann/ppx_protocol_conv";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.sempiternal-aurora ];
  };
})
