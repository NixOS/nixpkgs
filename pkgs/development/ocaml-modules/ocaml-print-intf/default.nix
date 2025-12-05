{
  lib,
  fetchFromGitHub,
  buildDunePackage,
  dune-build-info,
  bos,
}:

buildDunePackage (finalAttrs: {
  pname = "ocaml-print-intf";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "avsm";
    repo = "ocaml-print-intf";
    tag = "v${finalAttrs.version}";
    hash = "sha256-16LVvyTHew7sYfr4x0WR/jikXq4dy7Yi9yyrHA99hEM=";
  };

  buildInputs = [
    dune-build-info
    bos
  ];

  meta = {
    description = "Pretty print an OCaml cmi/cmt/cmti file in human-readable OCaml signature form";
    homepage = "https://github.com/avsm/ocaml-print-intf";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.nerdypepper ];
  };
})
