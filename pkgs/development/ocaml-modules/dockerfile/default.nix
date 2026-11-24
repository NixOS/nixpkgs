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
  version = "8.4.8";

  src = fetchFromGitHub {
    owner = "ocurrent";
    repo = "ocaml-dockerfile";
    tag = finalAttrs.version;
    hash = "sha256-iGtTJL+cTaISMsEk0j3bBzSg0T6+Oiisj6F8P8hppdU=";
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
