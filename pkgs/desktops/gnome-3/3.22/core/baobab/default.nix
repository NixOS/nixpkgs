{ stdenv, intltool, fetchurl, vala, libgtop
, pkgconfig, gtk3, glib
, bash, wrapGAppsHook, itstool, libxml2
, gnome3, librsvg, gdk_pixbuf, file }:

stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

  doCheck = true;

  NIX_CFLAGS_COMPILE = "-I${gnome3.glib.dev}/include/gio-unix-2.0";

  buildInputs = [ vala pkgconfig gtk3 glib libgtop intltool itstool libxml2
                  wrapGAppsHook file gdk_pixbuf gnome3.defaultIconTheme librsvg ];

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Baobab;
    description = "Graphical application to analyse disk usage in any Gnome environment";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
