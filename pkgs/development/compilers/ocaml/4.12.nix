import ./generic.nix {
  major_version = "4";
  minor_version = "12";
  patch_version = "0-alpha1";
  src = fetchTarball {
    url = "http://caml.inria.fr/pub/distrib/ocaml-4.12/ocaml-4.12.0~alpha1.tar.xz";
    sha256 = "1p9nnj7l43b697b6bm767znbf1h0s2lyc1qb8izr1vfpsmnm11ws";
  };
}
