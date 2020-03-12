{ stdenv, gettext, fetchurl, wrapGAppsHook, gnome-video-effects, libcanberra-gtk3
, pkgconfig, gtk3, glib, clutter-gtk, clutter-gst, udev, gst_all_1, itstool
, libgudev, vala, docbook_xml_dtd_43, docbook_xsl, appstream-glib
, libxslt, yelp-tools, gnome-common, gtk-doc
, adwaita-icon-theme, librsvg, totem, gdk-pixbuf, gnome3, gnome-desktop, libxml2
, meson, ninja, dbus, python3 }:

stdenv.mkDerivation rec {
  pname = "cheese";
  version = "3.34.0";

  src = fetchurl {
    url = "mirror://gnome/sources/cheese/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0wvyc9wb0avrprvm529m42y5fkv3lirdphqydc9jw0c8mh05d1ni";
  };

  postPatch = ''
    chmod +x meson_post_install.py
    patchShebangs meson_post_install.py
  '';

  passthru = {
    updateScript = gnome3.updateScript { packageName = "cheese"; attrPath = "gnome3.cheese"; };
  };

  nativeBuildInputs = [
    meson ninja pkgconfig gettext itstool vala wrapGAppsHook libxml2 appstream-glib
    libxslt docbook_xml_dtd_43 docbook_xsl
    gtk-doc yelp-tools gnome-common python3
  ];
  buildInputs = [ gtk3 glib gnome-video-effects
                  gdk-pixbuf adwaita-icon-theme librsvg udev gst_all_1.gstreamer
                  gst_all_1.gst-plugins-base gst_all_1.gst-plugins-good gnome-desktop
                  gst_all_1.gst-plugins-bad clutter-gtk clutter-gst
                  libcanberra-gtk3 libgudev dbus ];

  outputs = [ "out" "man" "devdoc" ];

  preFixup = ''
    gappsWrapperArgs+=(
      # Effects
      --prefix XDG_DATA_DIRS : "${gnome-video-effects}/share"
      # vp8enc preset
      --prefix GST_PRESET_PATH : "${gst_all_1.gst-plugins-good}/share/gstreamer-1.0/presets"
      # Thumbnailers
      --prefix XDG_DATA_DIRS : "${gdk-pixbuf}/share"
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
