{ stdenv, fetchurl, pkgconfig, glib, libxslt, gtk, webkitgtk, json_glib, rest, libsecret, dbus_glib
, telepathy_glib, intltool, dbus_libs, icu, libsoup, docbook_xsl_ns, docbook_xsl
}:

stdenv.mkDerivation rec {
  name = "gnome-online-accounts-3.12.2";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-online-accounts/3.12/${name}.tar.xz";
    sha256 = "cac7758e09d32eb54af50ab6b23d65da0c8d48c555c8db011a0cf5b977d542ec";
  };

  NIX_CFLAGS_COMPILE = "-I${dbus_glib}/include/dbus-1.0 -I${dbus_libs}/include/dbus-1.0";

  enableParallelBuilding = true;

  buildInputs = [ pkgconfig glib libxslt gtk webkitgtk json_glib rest libsecret dbus_glib telepathy_glib intltool icu libsoup docbook_xsl_ns docbook_xsl];

  meta = with stdenv.lib; {
    platforms = platforms.linux;
  };
}
