{ stdenv, intltool, fetchurl, exempi, libxml2
, pkgconfig, gtk3, glib, tracker, tracker-miners
, makeWrapper, itstool, gegl, babl, lcms2
, desktop-file-utils, gmp, libmediaart, wrapGAppsHook
, gnome3, librsvg, gdk_pixbuf, libexif, gexiv2, geocode-glib
, dleyna-renderer }:

stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

  # doCheck = true;

  NIX_CFLAGS_COMPILE = "-I${gnome3.glib.dev}/include/gio-unix-2.0";

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ gtk3 glib intltool itstool gegl babl gnome3.libgdata
                  gnome3.gsettings-desktop-schemas makeWrapper gmp libmediaart
                  gdk_pixbuf gnome3.defaultIconTheme librsvg exempi
                  gnome3.gfbgraph gnome3.grilo-plugins gnome3.grilo
                  gnome3.gnome-online-accounts gnome3.gnome-desktop
                  lcms2 libexif tracker tracker-miners libxml2 desktop-file-utils
                  wrapGAppsHook gexiv2 geocode-glib dleyna-renderer ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Photos;
    description = "Photos is an application to access, organize and share your photos with GNOME 3";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
