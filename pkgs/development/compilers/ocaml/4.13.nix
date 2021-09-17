import ./generic.nix {
  major_version = "4";
  minor_version = "13";
  patch_version = "0-rc1";
  src = fetchTarball {
    url = "https://caml.inria.fr/pub/distrib/ocaml-4.13/ocaml-4.13.0~rc1.tar.xz";
    sha256 = "0vp19qwdny5z428yjvdn0yxvf3i5l23axjb83y5ccj0rpza1k0im";
  };
}
