{ lib
, stdenv
, meson
, ninja
, gettext
, fetchurl
, pkg-config
, gtk4
, glib
, icu
, wrapGAppsHook4
, gnome
, libportal-gtk4
, libxml2
, itstool
, webkitgtk_6_0
, libsoup_3
, glib-networking
, libsecret
, gnome-desktop
, libarchive
, p11-kit
, sqlite
, gcr_4
, isocodes
, desktop-file-utils
, nettle
, gdk-pixbuf
, gst_all_1
, json-glib
, libadwaita
, buildPackages
, withPantheon ? false
, pantheon
}:

stdenv.mkDerivation rec {
  pname = "epiphany";
  version = "45.1";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.major version}/${pname}-${version}.tar.xz";
    sha256 = "fJlO807NYOkV3jMe4SPAiTj5YjzvrabVC5njycWtgTU=";
  };

  nativeBuildInputs = [
    desktop-file-utils
    gettext
    itstool
    meson
    ninja
    pkg-config
    wrapGAppsHook4
    buildPackages.glib
    buildPackages.gtk4
  ];

  buildInputs = [
    gcr_4
    gdk-pixbuf
    glib
    glib-networking
    gnome-desktop
    gst_all_1.gst-libav
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-ugly
    gst_all_1.gstreamer
    gtk4
    icu
    isocodes
    json-glib
    libadwaita
    libportal-gtk4
    libarchive
    libsecret
    libsoup_3
    libxml2
    nettle
    p11-kit
    sqlite
    webkitgtk_6_0
  ] ++ lib.optionals withPantheon [
    pantheon.granite7
  ];

  # Tests need an X display
  mesonFlags = [
    "-Dunit_tests=disabled"
  ] ++ lib.optionals withPantheon [
    "-Dgranite=enabled"
  ];

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
    };
  };

  meta = with lib; {
    homepage = "https://wiki.gnome.org/Apps/Epiphany";
    description = "WebKit based web browser for GNOME";
    maintainers = teams.gnome.members ++ teams.pantheon.members;
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
