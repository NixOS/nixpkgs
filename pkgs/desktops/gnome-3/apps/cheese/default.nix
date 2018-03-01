{ stdenv, intltool, fetchurl, wrapGAppsHook, gnome-video-effects, libcanberra-gtk3
, pkgconfig, gtk3, glib, clutter-gtk, clutter-gst, udev, gst_all_1, itstool
, libgudev, autoreconfHook, vala, docbook_xml_dtd_43, docbook_xsl, appstream-glib
, libxslt, yelp-tools, gnome-common, gtk-doc
, adwaita-icon-theme, librsvg, totem, gdk_pixbuf, gnome3, gnome-desktop, libxml2 }:

stdenv.mkDerivation rec {
  name = "cheese-${version}";
  version = "3.26.0";

  src = fetchurl {
    url = "mirror://gnome/sources/cheese/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "8ef52fc41de1817c4e4274e23eb7c29d28b64ae0f0d1fec52e184e99aea6c605";
  };

  passthru = {
    updateScript = gnome3.updateScript { packageName = "cheese"; attrPath = "gnome3.cheese"; };
  };

  nativeBuildInputs = [
    pkgconfig intltool itstool vala wrapGAppsHook libxml2 appstream-glib
    libxslt docbook_xml_dtd_43 docbook_xsl
    autoreconfHook gtk-doc yelp-tools gnome-common
  ];
  buildInputs = [ gtk3 glib gnome-video-effects
                  gdk_pixbuf adwaita-icon-theme librsvg udev gst_all_1.gstreamer
                  gst_all_1.gst-plugins-base gst_all_1.gst-plugins-good gnome-desktop
                  gst_all_1.gst-plugins-bad clutter-gtk clutter-gst
                  libcanberra-gtk3 libgudev ];

  outputs = [ "out" "man" "devdoc" ];

  patches = [
    gtk-doc.respect_xml_catalog_files_var_patch
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
