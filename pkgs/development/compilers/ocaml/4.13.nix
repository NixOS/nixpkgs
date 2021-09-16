import ./generic.nix {
  major_version = "4";
  minor_version = "13";
  patch_version = "0-rc2";
  src = fetchTarball {
    url = "https://caml.inria.fr/pub/distrib/ocaml-4.13/ocaml-4.13.0~rc2.tar.xz";
    sha256 = "1w4sdrs5s1bhbisgz44ysi2j1n13qd3slgs34ppglpwmqqw6ply2";
  };
}
