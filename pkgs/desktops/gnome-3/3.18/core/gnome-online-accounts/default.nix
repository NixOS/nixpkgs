{ stdenv, fetchurl, pkgconfig, glib, libxslt, gtk, makeWrapper
, webkitgtk, json_glib, rest, libsecret, dbus_glib, gnome_common
, telepathy_glib, intltool, dbus_libs, icu, autoreconfHook
, libsoup, docbook_xsl_ns, docbook_xsl, gnome3, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

  NIX_CFLAGS_COMPILE = "-I${dbus_glib.dev}/include/dbus-1.0 -I${dbus_libs.dev}/include/dbus-1.0";

  enableParallelBuilding = true;

  preAutoreconf = ''
    sed '/disable-settings/d' -i configure.ac
    sed "/if HAVE_INTROSPECTION/a INTROSPECTION_COMPILER_ARGS = --shared-library=$out/lib/libgoa-1.0.so" -i src/goa/Makefile.am
  '';

  buildInputs = [ pkgconfig glib libxslt gtk webkitgtk json_glib rest gnome_common wrapGAppsHook
                  libsecret dbus_glib telepathy_glib intltool icu libsoup autoreconfHook
                  docbook_xsl_ns docbook_xsl gnome3.defaultIconTheme  ];


  meta = with stdenv.lib; {
    platforms = platforms.linux;
    maintainers = gnome3.maintainers;
  };
}
