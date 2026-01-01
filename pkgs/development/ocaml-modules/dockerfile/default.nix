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
<<<<<<< HEAD
  version = "8.3.4";
=======
  version = "8.3.3";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "ocurrent";
    repo = "ocaml-dockerfile";
    tag = finalAttrs.version;
<<<<<<< HEAD
    hash = "sha256-q8yzuRkGVe/t0N0HFLFqOPNyvWSxf4WHApZVk1CG1qw=";
=======
    hash = "sha256-F58KnC4YpsS0ehmi6efFMT+WG5BDuYfQOA1RsFVtO/8=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
