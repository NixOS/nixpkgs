{ stdenv, fetchurl, pkgconfig, glib, libxslt, gtk, webkitgtk, json_glib, rest, libsecret, dbus_glib
, telepathy_glib, intltool, dbus_libs, icu, libsoup, docbook_xsl_ns, docbook_xsl
}:

stdenv.mkDerivation rec {
  name = "gnome-online-accounts-3.10.2";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-online-accounts/3.10/${name}.tar.xz";
    sha256 = "15qvw40dmi886491s3abpidsm2lx65fhglhj99bvcdskhk0ih90b";
  };

  NIX_CFLAGS_COMPILE = "-I${dbus_glib}/include/dbus-1.0 -I${dbus_libs}/include/dbus-1.0";

  enableParallelBuilding = true;

  buildInputs = [ pkgconfig glib libxslt gtk webkitgtk json_glib rest libsecret dbus_glib telepathy_glib intltool icu libsoup docbook_xsl_ns docbook_xsl];

  meta = with stdenv.lib; {
    platforms = platforms.linux;
  };
}
