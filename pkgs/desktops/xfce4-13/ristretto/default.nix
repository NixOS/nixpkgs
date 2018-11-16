{ mkXfceDerivation, automakeAddFlags, exo, dbus-glib, gtk2, libexif
, libxfce4ui, libxfce4util, xfconf }:

mkXfceDerivation rec {
  category = "apps";
  pname = "ristretto";
  version = "0.8.3";

  postPatch = ''
    automakeAddFlags src/Makefile.am ristretto_CFLAGS DBUS_GLIB_CFLAGS
    automakeAddFlags src/Makefile.am ristretto_LDADD DBUS_GLIB_LIBS
  '';

  nativeBuildInputs = [ automakeAddFlags exo ];
  buildInputs = [ dbus-glib gtk2 libexif libxfce4ui libxfce4util xfconf ];

  sha256 = "02i61ddzpv0qjwahkksnzla57zdmkywyg1qrqs57z4bzj6l4nmkx";
}
