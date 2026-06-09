import ./generic.nix {
  major_version = "4";
  minor_version = "14";
  patch_version = "3";
  sha256 = "sha256-pdWDuPurnqe/bPly75w45/7ay/9tt6NOMQURXTQ+sGk=";

  patches = [
    {
      url = "https://github.com/ocaml/ocaml/commit/929f9aa7c00b45acf2d42f3f127b4ee28f926407.patch";
      hash = "sha256-zeYT+JM71aUcl0sOG2ByjMpp3JPs7kDJ6BKcrZjzoDM=";
    }
  ];
}
