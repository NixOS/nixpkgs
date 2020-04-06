{ stdenv
, meson
, ninja
, gettext
, fetchurl
, fetchpatch
, pkgconfig
, gtk3
, glib
, icu
, wrapGAppsHook
, gnome3
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
  version = "3.36.0";

  src = fetchurl {
    url = "mirror://gnome/sources/epiphany/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1xjn6jk4dx2kl2llalydcyvibnpwjahp9z3210pflyy4k68pfw6l";
  };

  patches = [
    # Fix downloading files
    # https://gitlab.gnome.org/GNOME/epiphany/issues/1127
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/epiphany/commit/8682a084bab7e758a9b8efe1deaf0cb8d55fcf44.patch";
      sha256 = "bep+Q8Wpu84KA13a5T3JCz8nyeC13HT/QkMKvWT6vLk=";
    })
  ];

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
    homepage = https://wiki.gnome.org/Apps/Epiphany;
    description = "WebKit based web browser for GNOME";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
