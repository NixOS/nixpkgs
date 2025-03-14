{
  lib,
  fetchFromGitHub,
  buildDunePackage,
  base64,
  bos,
  core,
  core_kernel,
  core_unix ? null,
  lwt_react,
  ocamlgraph,
  ppx_sexp_conv,
  rresult,
  sexplib,
  tyxml,
}:

buildDunePackage rec {
  pname = "bistro";
  version = "unstable-2024-05-17";

  src = fetchFromGitHub {
    owner = "pveber";
    repo = pname;
    rev = "d44c44b52148e58ca3842c3efedf3115e376d800";
    sha256 = "sha256-naoCEVBfydqSeGGbXYBXfg0PP+Fzk05jFoul7XAz/tM=";
  };

  propagatedBuildInputs = [
    base64
    bos
    core
    core_kernel
    core_unix
    lwt_react
    ocamlgraph
    ppx_sexp_conv
    rresult
    sexplib
    tyxml
  ];

  minimalOCamlVersion = "4.14";

  meta = {
    inherit (src.meta) homepage;
    description = "Build and execute typed scientific workflows";
    maintainers = [ lib.maintainers.vbgl ];
    license = lib.licenses.gpl2;
  };
}
