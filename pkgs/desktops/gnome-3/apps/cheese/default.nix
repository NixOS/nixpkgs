{ stdenv, intltool, fetchurl, wrapGAppsHook, gnome-video-effects, libcanberra_gtk3
, pkgconfig, gtk3, glib, clutter_gtk, clutter-gst, udev, gst_all_1, itstool
, libgudev, autoreconfHook, vala, docbook_xml_dtd_43, docbook_xsl, appstream-glib
, libxslt, yelp_tools, gnome_common, gtk_doc
, adwaita-icon-theme, librsvg, totem, gdk_pixbuf, gnome3, gnome_desktop, libxml2 }:

stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

  nativeBuildInputs = [
    pkgconfig intltool itstool vala wrapGAppsHook libxml2 appstream-glib
    libxslt docbook_xml_dtd_43 docbook_xsl
    autoreconfHook gtk_doc yelp_tools gnome_common
  ];
  buildInputs = [ gtk3 glib gnome-video-effects
                  gdk_pixbuf adwaita-icon-theme librsvg udev gst_all_1.gstreamer
                  gst_all_1.gst-plugins-base gst_all_1.gst-plugins-good gnome_desktop
                  gst_all_1.gst-plugins-bad clutter_gtk clutter-gst
                  libcanberra_gtk3 libgudev ];

  outputs = [ "out" "man" "devdoc" ];

  patches = [
    gtk_doc.respect_xml_catalog_files_var_patch
  ];

  preFixup = ''
    gappsWrapperArgs+=(
      # Effects
      --prefix XDG_DATA_DIRS : "${gnome-video-effects}/share"
      # vp8enc preset
      --prefix GST_PRESET_PATH : "${gst_all_1.gst-plugins-good}/share/gstreamer-1.0/presets"
      # Thumbnailers
      --prefix XDG_DATA_DIRS : "${gdk_pixbuf}/share"
      --prefix XDG_DATA_DIRS : "${totem}/share"
    )
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Cheese;
    description = "Take photos and videos with your webcam, with fun graphical effects";
    maintainers = gnome3.maintainers;
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
