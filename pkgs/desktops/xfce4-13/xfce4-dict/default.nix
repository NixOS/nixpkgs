{ mkXfceDerivation, automakeAddFlags, gtk3, libxfce4ui, libxfce4util, xfce4-panel }:

mkXfceDerivation rec {
  category = "apps";
  pname = "xfce4-dict";
  version = "0.8.0";

  sha256 = "1r1k9cgl7zkn3q4mjf7qjql6vlxkb2m0spgj9p646mw7bnhbf9wr";

  patches = [ ./configure-gio.patch ];

  nativeBuildInputs = [ automakeAddFlags ];

  postPatch = ''
    automakeAddFlags lib/Makefile.am libdict_la_CFLAGS GIO_CFLAGS
  '';

  buildInputs = [ gtk3 libxfce4ui libxfce4util xfce4-panel ];
}
