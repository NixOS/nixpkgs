{ lib
, stdenv
, gettext
, fetchurl
, wrapGAppsHook
, gnome-video-effects
, libcanberra-gtk3
, pkg-config
, gtk3
, glib
, clutter-gtk
, clutter-gst
, gst_all_1
, itstool
, vala
, docbook_xml_dtd_43
, docbook-xsl-nons
, appstream-glib
, libxslt
, gtk-doc
, adwaita-icon-theme
, librsvg
, totem
, gdk-pixbuf
, gnome
, gnome-desktop
, libxml2
, meson
, ninja
, dbus
, python3
, pipewire
}:

stdenv.mkDerivation rec {
  pname = "cheese";
  version = "43.0";

  outputs = [ "out" "man" "devdoc" ];

  src = fetchurl {
    url = "mirror://gnome/sources/cheese/${lib.versions.major version}/${pname}-${version}.tar.xz";
    sha256 = "dFdMSjwycyfxotbQs/k3vir7B6YVm21425wZLeZmfws=";
  };

  nativeBuildInputs = [
    appstream-glib
    docbook_xml_dtd_43
    docbook-xsl-nons
    gettext
    gtk-doc
    itstool
    libxml2
    libxslt # for xsltproc
    meson
    ninja
    pkg-config
    python3
    vala
    wrapGAppsHook
    glib # for glib-compile-schemas
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
    librsvg
    pipewire # PipeWire provides a gstreamer plugin for using PipeWire for video
  ];

  postPatch = ''
    chmod +x meson_post_install.py
    patchShebangs meson_post_install.py
  '';

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

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "cheese";
      attrPath = "gnome.cheese";
    };
  };

  meta = with lib; {
    homepage = "https://wiki.gnome.org/Apps/Cheese";
    description = "Take photos and videos with your webcam, with fun graphical effects";
    maintainers = teams.gnome.members;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
