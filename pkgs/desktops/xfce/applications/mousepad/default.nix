{ mkXfceDerivation, exo, glib, gtk3, gtksourceview3, xfconf }:

mkXfceDerivation {
  category = "apps";
  pname = "mousepad";
  version = "0.5.1";
  odd-unstable = false;

  sha256 = "EAQnG+uy73HMY2l2zemb2oa8S8G7KpA/N1DKFGflKcQ=";

  nativeBuildInputs = [ exo ];
  buildInputs = [ glib gtk3 gtksourceview3 xfconf ];

  # See https://github.com/NixOS/nixpkgs/issues/36468
  NIX_CFLAGS_COMPILE = "-I${glib.dev}/include/gio-unix-2.0";

  meta = {
    description = "A simple text editor for Xfce";
  };
}
