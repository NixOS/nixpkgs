import ./generic.nix {
  major_version = "4";
  minor_version = "12";
  patch_version = "0-alpha3";
  src = fetchTarball {
    url = "http://caml.inria.fr/pub/distrib/ocaml-4.12/ocaml-4.12.0~alpha3.tar.xz";
    sha256 = "1hqlf9fi5gmvb6r13z5819rg6k813bw9ihgbbji67hhh4q361wlw";
  };
}
