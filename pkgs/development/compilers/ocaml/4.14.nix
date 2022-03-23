import ./generic.nix {
  major_version = "4";
  minor_version = "14";
  patch_version = "0-rc2";
  src = fetchTarball {
    url = "https://caml.inria.fr/pub/distrib/ocaml-4.14/ocaml-4.14.0~rc2.tar.xz";
    sha256 = "sha256:0ch8nyfk2mzwhmlxb434cyamp7n14zxhwsq1h8033g629kw50kb0";
  };
}
