{ stdenv, intltool, fetchurl, wrapGAppsHook, gnome-video-effects, libcanberra_gtk3
, pkgconfig, gtk3, glib, clutter_gtk, clutter-gst, udev, gst_all_1, itstool
, libgudev
, adwaita-icon-theme, librsvg, gdk_pixbuf, gnome3, gnome_desktop, libxml2 }:

stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

  buildInputs = [ pkgconfig gtk3 glib intltool wrapGAppsHook gnome-video-effects itstool
                  gdk_pixbuf adwaita-icon-theme librsvg udev gst_all_1.gstreamer libxml2
                  gst_all_1.gst-plugins-base gst_all_1.gst-plugins-good gnome_desktop
                  gst_all_1.gst-plugins-bad clutter_gtk clutter-gst
                  libcanberra_gtk3 libgudev ];

  enableParallelBuilding = true;

  NIX_CFLAGS_COMPILE = "-I${glib.dev}/include/gio-unix-2.0";

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Cheese;
    description = "Take photos and videos with your webcam, with fun graphical effects";
    maintainers = gnome3.maintainers;
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
