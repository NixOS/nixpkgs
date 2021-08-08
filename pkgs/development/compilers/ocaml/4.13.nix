import ./generic.nix {
  major_version = "4";
  minor_version = "13";
  patch_version = "0-alpha2";
  src = fetchTarball {
    url = "https://caml.inria.fr/pub/distrib/ocaml-4.13/ocaml-4.13.0~alpha2.tar.xz";
    sha256 = "0krb0254i6ihbymjn6mwgzcfrzsvpk9hbagl0agm6wml21zpcsif";
  };
}
