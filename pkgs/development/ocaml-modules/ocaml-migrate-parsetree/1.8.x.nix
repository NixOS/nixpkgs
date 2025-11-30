{
  lib,
  fetchFromGitHub,
  buildDunePackage,
  ocaml,
  result,
  ppx_derivers,
}:

buildDunePackage rec {
  pname = "ocaml-migrate-parsetree";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "ocaml-ppx";
    repo = pname;
    rev = "v${version}";
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
    inherit (src.meta) homepage;
    broken = lib.versionOlder "4.13" ocaml.version;
  };
}
