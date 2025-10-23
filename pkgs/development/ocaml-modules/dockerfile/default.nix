{
  lib,
  buildDunePackage,
  fetchFromGitHub,
  fmt,
  ppx_sexp_conv,
  sexplib,
  alcotest,
}:

buildDunePackage rec {
  pname = "dockerfile";
  version = "8.3.2";

  src = fetchFromGitHub {
    owner = "ocurrent";
    repo = "ocaml-dockerfile";
    tag = version;
    hash = "sha256-L4TjCf8SaNMxqkrr+AoL/Lx2oWgf2owJFs26lu68ejs=";
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
    changelog = "https://github.com/ocurrent/ocaml-dockerfile/blob/v${version}/CHANGES.md";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.ethancedwards8 ];
  };
}
