{ mkXfceDerivation, automakeAddFlags, exo, dbus_glib, gtk2, libexif
, libxfce4ui, libxfce4util, xfconf }:

mkXfceDerivation rec {
  category = "apps";
  pname = "ristretto";
  version = "0.8.2";

  postPatch = ''
    automakeAddFlags src/Makefile.am ristretto_CFLAGS DBUS_GLIB_CFLAGS
    automakeAddFlags src/Makefile.am ristretto_LDADD DBUS_GLIB_LIBS
  '';

  nativeBuildInputs = [ automakeAddFlags exo ];
  buildInputs = [ dbus_glib gtk2 libexif libxfce4ui libxfce4util xfconf ];

  sha256 = "0ra50452ldk91pvhcpl3f3rhdssw3djfr6cm0hc29v8r58am0wni";
}
