import ./generic.nix {
  major_version = "5";
  minor_version = "2";
  patch_version = "0-beta1";
  src = fetchTarball {
    url = "https://caml.inria.fr/pub/distrib/ocaml-5.2/ocaml-5.2.0~beta1.tar.xz";
    sha256 = "sha256:0prf87a41k2y1znnh2pjkggrvhh5cihj68sxqrjn162889rf7wam";
  };
}
