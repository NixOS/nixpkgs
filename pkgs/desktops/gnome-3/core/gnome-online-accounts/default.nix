{ stdenv, fetchurl, pkgconfig, vala, glib, libxslt, gtk, wrapGAppsHook
, webkitgtk, json_glib, rest, libsecret, dbus_glib, gnome_common, gtk_doc
, telepathy_glib, intltool, dbus_libs, icu, glib_networking
, libsoup, docbook_xsl_ns, docbook_xsl, gnome3, gcr, kerberos
}:

stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

  NIX_CFLAGS_COMPILE = "-I${dbus_glib.dev}/include/dbus-1.0 -I${dbus_libs.dev}/include/dbus-1.0";

  outputs = [ "out" "man" "dev" "devdoc" ];

  configureFlags = [
    "--enable-media-server"
    "--enable-kerberos"
    "--enable-lastfm"
    "--enable-todoist"
    "--enable-gtk-doc"
  ];

  enableParallelBuilding = true;

  nativeBuildInputs = [
    pkgconfig vala gnome_common intltool wrapGAppsHook
    libxslt docbook_xsl_ns docbook_xsl gtk_doc
  ];
  buildInputs = [
    glib gtk webkitgtk json_glib rest libsecret dbus_glib telepathy_glib glib_networking icu libsoup
    gcr kerberos
  ];

  meta = with stdenv.lib; {
    platforms = platforms.linux;
    maintainers = gnome3.maintainers;
  };
}
