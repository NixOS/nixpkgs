{ mkXfceDerivation, automakeAddFlags, exo, dbus-glib, gtk2, libexif
, libxfce4ui, libxfce4util, xfconf }:

mkXfceDerivation rec {
  category = "apps";
  pname = "ristretto";
  version = "0.8.4";

  postPatch = ''
    automakeAddFlags src/Makefile.am ristretto_CFLAGS DBUS_GLIB_CFLAGS
    automakeAddFlags src/Makefile.am ristretto_LDADD DBUS_GLIB_LIBS
  '';

  nativeBuildInputs = [ automakeAddFlags exo ];
  buildInputs = [ dbus-glib gtk2 libexif libxfce4ui libxfce4util xfconf ];

  sha256 = "0vnivwl0xwhzpflys9zwds6x9gqd3v069qn04afmakhi2m8qr6hf";
}
