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
    sha256 = "16x8sxc4ygxrr1868qpzfqyrvjf3hfxvjzmxmf6ibgglq7ixa2nq";
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
