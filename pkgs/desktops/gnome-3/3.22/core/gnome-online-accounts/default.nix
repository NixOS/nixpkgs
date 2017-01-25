{ stdenv, fetchurl, pkgconfig, glib, libxslt, gtk, makeWrapper
, webkitgtk, json_glib, rest, libsecret, dbus_glib, gnome_common
, telepathy_glib, intltool, dbus_libs, icu
, libsoup, docbook_xsl_ns, docbook_xsl, gnome3
}:

stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

  NIX_CFLAGS_COMPILE = "-I${dbus_glib.dev}/include/dbus-1.0 -I${dbus_libs.dev}/include/dbus-1.0";

  enableParallelBuilding = true;

  buildInputs = [ pkgconfig glib libxslt gtk webkitgtk json_glib rest gnome_common makeWrapper
                  libsecret dbus_glib telepathy_glib intltool icu libsoup
                  docbook_xsl_ns docbook_xsl gnome3.defaultIconTheme ];

  preFixup = ''
    for f in "$out/libexec/"*; do
      wrapProgram "$f" --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH"
    done
  '';

  meta = with stdenv.lib; {
    platforms = platforms.linux;
    maintainers = gnome3.maintainers;
  };
}
