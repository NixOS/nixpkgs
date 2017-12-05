{ stdenv, fetchurl, pkgconfig, vala, glib, libxslt, gtk, wrapGAppsHook
, webkitgtk, json_glib, rest, libsecret, dbus_glib, gnome_common
, telepathy_glib, intltool, dbus_libs, icu, glib_networking
, libsoup, docbook_xsl_ns, docbook_xsl, gnome3
}:

stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

  NIX_CFLAGS_COMPILE = "-I${dbus_glib.dev}/include/dbus-1.0 -I${dbus_libs.dev}/include/dbus-1.0";

  outputs = [ "out" "man" "dev" ];

  enableParallelBuilding = true;

  nativeBuildInputs = [
    pkgconfig vala gnome_common intltool wrapGAppsHook
    libxslt docbook_xsl_ns docbook_xsl
  ];
  buildInputs = [
    glib gtk webkitgtk json_glib rest libsecret dbus_glib telepathy_glib glib_networking icu libsoup
  ];

  meta = with stdenv.lib; {
    platforms = platforms.linux;
    maintainers = gnome3.maintainers;
  };
}
