{ stdenv
, meson
, ninja
, gettext
, fetchurl
, pkgconfig
, gtk3
, glib
, icu
, wrapGAppsHook
, gnome3
, libportal
, libxml2
, libxslt
, itstool
, webkitgtk
, libsoup
, glib-networking
, libsecret
, gnome-desktop
, libnotify
, p11-kit
, sqlite
, gcr
, isocodes
, desktop-file-utils
, python3
, nettle
, gdk-pixbuf
, gst_all_1
, json-glib
, libdazzle
, libhandy
, buildPackages
}:

stdenv.mkDerivation rec {
  pname = "epiphany";
  version = "3.38.0";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0ln5i5wnyi1qbx5awz513sdxx2x8nn0nrk2yvgj431bzgh6q53i2";
  };

  # Tests need an X display
  mesonFlags = [
    "-Dunit_tests=disabled"
  ];

  nativeBuildInputs = [
    desktop-file-utils
    gettext
    itstool
    libxslt
    meson
    ninja
    pkgconfig
    python3
    wrapGAppsHook
    buildPackages.glib
    buildPackages.gtk3
  ];

  buildInputs = [
    gcr
    gdk-pixbuf
    glib
    glib-networking
    gnome-desktop
    gnome3.adwaita-icon-theme
    gst_all_1.gst-libav
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-ugly
    gst_all_1.gstreamer
    gtk3
    icu
    isocodes
    json-glib
    libdazzle
    libhandy
    libportal
    libnotify
    libsecret
    libsoup
    libxml2
    nettle
    p11-kit
    sqlite
    webkitgtk
  ];

  postPatch = ''
    chmod +x post_install.py # patchShebangs requires executable file
    patchShebangs post_install.py
  '';

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
    };
  };

  meta = with stdenv.lib; {
    homepage = "https://wiki.gnome.org/Apps/Epiphany";
    description = "WebKit based web browser for GNOME";
    maintainers = teams.gnome.members;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
