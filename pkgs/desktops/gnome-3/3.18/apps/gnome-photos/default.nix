{ stdenv, intltool, fetchurl, exempi, libxml2
, pkgconfig, gtk3, glib
, makeWrapper, itstool, gegl, babl, lcms2
, desktop_file_utils, gmp, libmediaart, wrapGAppsHook
, gnome3, librsvg, gdk_pixbuf, libexif }:

stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

  # doCheck = true;

  NIX_CFLAGS_COMPILE = "-I${gnome3.glib.dev}/include/gio-unix-2.0";

  buildInputs = [ pkgconfig gtk3 glib intltool itstool gegl babl gnome3.libgdata
                  gnome3.gsettings_desktop_schemas makeWrapper gmp libmediaart
                  gdk_pixbuf gnome3.defaultIconTheme librsvg exempi
                  gnome3.gfbgraph gnome3.grilo-plugins gnome3.grilo
                  gnome3.gnome_online_accounts gnome3.gnome_desktop
                  lcms2 libexif gnome3.tracker libxml2 desktop_file_utils
                  wrapGAppsHook ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Photos;
    description = "Photos is an application to access, organize and share your photos with GNOME 3";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
