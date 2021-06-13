import ./generic.nix {
  major_version = "4";
  minor_version = "13";
  patch_version = "0-alpha1";
  src = fetchTarball {
    url = "https://caml.inria.fr/pub/distrib/ocaml-4.13/ocaml-4.13.0~alpha1.tar.xz";
    sha256 = "071k12q8m2w9bcwvfclyc46pwd9r49v6av36fhjdlqq29niyq915";
  };
}
