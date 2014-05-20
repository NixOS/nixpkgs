{ stdenv, fetchurl, pkgconfig, intltool, gnupg, p11_kit, glib
, libgcrypt, libtasn1, dbus_glib, gtk, pango, gdk_pixbuf, atk
, gobjectIntrospection, makeWrapper, libxslt, vala }:

stdenv.mkDerivation rec {
  name = "gcr-3.12.2";

  src = fetchurl {
    url = "mirror://gnome/sources/gcr/3.12/${name}.tar.xz";
    sha256 = "456e20615ab178aa92eeabdea64dcce535c10d5af189171d9375291a2447d21c";
  };

  buildInputs = [
    pkgconfig intltool gnupg p11_kit glib gobjectIntrospection libxslt
    libgcrypt libtasn1 dbus_glib gtk pango gdk_pixbuf atk makeWrapper vala
  ];

  #doCheck = true;

  preFixup = ''
    wrapProgram "$out/bin/gcr-viewer" \
      --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH"
  '';

  meta = with stdenv.lib; {
    platforms = platforms.linux;
  };
}
