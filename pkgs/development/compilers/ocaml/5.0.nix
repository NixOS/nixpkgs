import ./generic.nix {
  major_version = "5";
  minor_version = "0";
  patch_version = "0-rc1";
  src = fetchTarball {
    url = "https://caml.inria.fr/pub/distrib/ocaml-5.0/ocaml-5.0.0~rc1.tar.xz";
    sha256 = "sha256:1ql9rmh2g9fhfv99vk9sdca1biiin32vi4idgdgl668n0vb8blw8";
  };
}
