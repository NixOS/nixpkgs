{ mkXfceDerivation, exo, glib, gtk3, gtksourceview3, xfconf }:

mkXfceDerivation {
  category = "apps";
  pname = "mousepad";
  version = "0.4.2";

  sha256 = "0a35vaq4l0d8vzw7hqpvbgkr3wj1sqr2zvj7bc5z4ikz2cppqj7p";

  nativeBuildInputs = [ exo ];
  buildInputs = [ glib gtk3 gtksourceview3 xfconf ];

  # See https://github.com/NixOS/nixpkgs/issues/36468
  NIX_CFLAGS_COMPILE = "-I${glib.dev}/include/gio-unix-2.0";
}
