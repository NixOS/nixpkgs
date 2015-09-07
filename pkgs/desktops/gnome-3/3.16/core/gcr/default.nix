{ stdenv, fetchurl, pkgconfig, intltool, gnupg, p11_kit, glib
, libgcrypt, libtasn1, dbus_glib, gtk, pango, gdk_pixbuf, atk
, gobjectIntrospection, makeWrapper, libxslt, vala, gnome3 }:

stdenv.mkDerivation rec {
  name = "gcr-${gnome3.version}.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gcr/${gnome3.version}/${name}.tar.xz";
    sha256 = "0xfhi0w358lvca1jjx24x2gm67mif33dsnmi9cv5i0f83ks8vzpc";
  };

  buildInputs = [
    pkgconfig intltool gnupg glib gobjectIntrospection libxslt
    libgcrypt libtasn1 dbus_glib gtk pango gdk_pixbuf atk makeWrapper vala
  ];

  propagatedBuildInputs = [ p11_kit ];

  #doCheck = true;

  enableParallelBuilding = true;

  preFixup = ''
    wrapProgram "$out/bin/gcr-viewer" \
      --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH"
  '';

  meta = with stdenv.lib; {
    platforms = platforms.linux;
    maintainers = gnome3.maintainers;
  };
}
