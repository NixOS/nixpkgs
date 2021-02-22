import ./generic.nix {
  major_version = "4";
  minor_version = "12";
  patch_version = "0-beta1";
  src = fetchTarball {
    url = "http://caml.inria.fr/pub/distrib/ocaml-4.12/ocaml-4.12.0~beta1.tar.xz";
    sha256 = "1rny74mi0knl8byqg2naw1mgvn22c2zihlwvzbkd56j97flqsxsm";
  };
}
