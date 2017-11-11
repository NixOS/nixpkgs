{ stdenv, fetchurl, meson, ninja, glib, pkgconfig, gnome3, appstream-glib, gettext }:

stdenv.mkDerivation rec {
  name = "nautilus-sendto-${version}";

  version = "3.8.6";

  src = fetchurl {
    url = "mirror://gnome/sources/nautilus-sendto/3.8/${name}.tar.xz";
    sha256 = "164d7c6e8bae29c4579bcc67a7bf50d783662b1545b62f3008e7ea3c0410e04d";
  };

  nativeBuildInputs = [ meson ninja pkgconfig appstream-glib gettext ];
  buildInputs = [ glib ];

  meta = with stdenv.lib; {
    description = "Integrates Evolution and Pidgin into the Nautilus file manager";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
