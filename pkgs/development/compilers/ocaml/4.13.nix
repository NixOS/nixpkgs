import ./generic.nix {
  major_version = "4";
  minor_version = "13";
  patch_version = "0-beta1";
  src = fetchTarball {
    url = "https://caml.inria.fr/pub/distrib/ocaml-4.13/ocaml-4.13.0~beta1.tar.xz";
    sha256 = "0dbz69p1kqabjvzaasy2malfdfn4b93s504x2xs0dl5l3fa3p6c3";
  };
}
