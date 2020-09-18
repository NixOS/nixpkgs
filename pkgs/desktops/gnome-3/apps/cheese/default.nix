{ stdenv
, gettext
, fetchurl
, wrapGAppsHook
, gnome-video-effects
, libcanberra-gtk3
, pkgconfig
, gtk3
, glib
, clutter-gtk
, clutter-gst
, udev
, gst_all_1
, itstool
, libgudev
, vala
, docbook_xml_dtd_43
, docbook_xsl
, appstream-glib
, libxslt
, yelp-tools
, gnome-common
, gtk-doc
, adwaita-icon-theme
, librsvg
, totem
, gdk-pixbuf
, gnome3
, gnome-desktop
, libxml2
, meson
, ninja
, dbus
, python3
}:

stdenv.mkDerivation rec {
  pname = "cheese";
  version = "3.38.0";

  src = fetchurl {
    url = "mirror://gnome/sources/cheese/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0vyim2avlgq3a48rgdfz5g21kqk11mfb53b2l883340v88mp7ll8";
  };

  postPatch = ''
    chmod +x meson_post_install.py
    patchShebangs meson_post_install.py
  '';

  passthru = {
    updateScript = gnome3.updateScript { packageName = "cheese"; attrPath = "gnome3.cheese"; };
  };

  nativeBuildInputs = [
    appstream-glib
    docbook_xml_dtd_43
    docbook_xsl
    gettext
    gnome-common
    gtk-doc
    itstool
    libxml2
    libxslt
    meson
    ninja
    pkgconfig
    python3
    vala
    wrapGAppsHook
    yelp-tools
  ];

  buildInputs = [
    adwaita-icon-theme
    clutter-gst
    clutter-gtk
    dbus
    gdk-pixbuf
    glib
    gnome-desktop
    gnome-video-effects
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gstreamer
    gtk3
    libcanberra-gtk3
    libgudev
    librsvg
    udev
  ];

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
    homepage = "https://wiki.gnome.org/Apps/Cheese";
    description = "Take photos and videos with your webcam, with fun graphical effects";
    maintainers = teams.gnome.members;
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
