{
  lib,
  buildDunePackage,
  fetchFromGitHub,
  fmt,
  ppx_sexp_conv,
  sexplib,
  alcotest,
}:

buildDunePackage (finalAttrs: {
  pname = "dockerfile";
  version = "8.3.3";

  src = fetchFromGitHub {
    owner = "ocurrent";
    repo = "ocaml-dockerfile";
    tag = finalAttrs.version;
    hash = "sha256-F58KnC4YpsS0ehmi6efFMT+WG5BDuYfQOA1RsFVtO/8=";
  };

  propagatedBuildInputs = [
    fmt
    ppx_sexp_conv
    sexplib
  ];

  checkInputs = [
    alcotest
  ];

  doCheck = true;

  meta = {
    description = "Interface for creating Dockerfiles";
    homepage = "https://www.ocurrent.org/ocaml-dockerfile/dockerfile/Dockerfile/index.html";
    downloadPage = "https://github.com/ocurrent/ocaml-dockerfile";
    changelog = "https://github.com/ocurrent/ocaml-dockerfile/blob/${finalAttrs.version}/CHANGES.md";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.ethancedwards8 ];
  };
})
