import ./generic.nix rec {
  major_version = "4";
  minor_version = "02";
  patch_version = "3";
  patches = [ ./ocamlbuild.patch ];
  sha256 = "1qwwvy8nzd87hk8rd9sm667nppakiapnx4ypdwcrlnav2dz6kil3";
}
