{ stdenv, fetchurl, pkgconfig, intltool, gnupg, p11_kit, glib
, libgcrypt, libtasn1, dbus_glib, gtk, pango, gdk_pixbuf, atk
, gobjectIntrospection, makeWrapper, libxslt, vala, gnome3 }:

stdenv.mkDerivation rec {
  name = "gcr-3.14.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gcr/3.14/${name}.tar.xz";
    sha256 = "2a2231147a01e2061f57fa9ca77557ff97bc6ceab028cee5528079f4b2fca63d";
  };

  buildInputs = [
    pkgconfig intltool gnupg glib gobjectIntrospection libxslt
    libgcrypt libtasn1 dbus_glib gtk pango gdk_pixbuf atk makeWrapper vala
  ];

  propagatedBuildInputs = [ p11_kit ];

  #doCheck = true;

  preFixup = ''
    wrapProgram "$out/bin/gcr-viewer" \
      --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH"
  '';

  meta = with stdenv.lib; {
    platforms = platforms.linux;
    maintainers = gnome3.maintainers;
  };
}
