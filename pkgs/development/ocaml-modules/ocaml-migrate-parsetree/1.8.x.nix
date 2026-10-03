{
  lib,
  fetchFromGitHub,
  buildDunePackage,
  ocaml,
  result,
  ppx_derivers,
}:

buildDunePackage (finalAttrs: {
  pname = "ocaml-migrate-parsetree";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "ocaml-ppx";
    repo = "ocaml-migrate-parsetree";
    rev = "v${finalAttrs.version}";
    hash = "sha256-2ArV48H0vRWNq71+ubuDw8mdPXb/YmRQyLk/T1jXqJs=";
  };

  propagatedBuildInputs = [
    ppx_derivers
    result
  ];

  meta = {
    description = "Convert OCaml parsetrees between different major versions";
    license = lib.licenses.lgpl21;
    maintainers = [ lib.maintainers.vbgl ];
    inherit (finalAttrs.src.meta) homepage;
    broken = lib.versionOlder "4.13" ocaml.version;
  };
})
