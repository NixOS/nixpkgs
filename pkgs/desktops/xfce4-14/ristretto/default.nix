{ mkXfceDerivation, automakeAddFlags, exo, dbus-glib, gtk3, libexif
, libxfce4ui, libxfce4util, xfconf }:

mkXfceDerivation rec {
  category = "apps";
  pname = "ristretto";
  version = "0.10.0";

  sha256 = "07h7wbq3xh2ac6q4kp2ai1incfn0zfxxngap7hzqx47a5xw2mrm8";

  postPatch = ''
    automakeAddFlags src/Makefile.am ristretto_CFLAGS DBUS_GLIB_CFLAGS
    automakeAddFlags src/Makefile.am ristretto_LDADD DBUS_GLIB_LIBS
  '';

  nativeBuildInputs = [ automakeAddFlags exo ];
  buildInputs = [ dbus-glib gtk3 libexif libxfce4ui libxfce4util xfconf ];
}
