{ lib
, stdenv
, meson
, ninja
, gettext
, fetchurl
, fetchpatch
, pkg-config
, gtk3
, glib
, icu
, wrapGAppsHook
, gnome
, libportal-gtk3
, libxml2
, libxslt
, itstool
, webkitgtk_4_1
, libsoup_3
, glib-networking
, libsecret
, gnome-desktop
, libnotify
, libarchive
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
, withPantheon ? false
}:

stdenv.mkDerivation rec {
  pname = "epiphany";
  version = "43.alpha";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.major version}/${pname}-${version}.tar.xz";
    sha256 = "TVm7+mQ59arqnWD94npf6GdciFP8uugPSmjZ8CjDF0E=";
  };

  patches = lib.optionals withPantheon [
    # Pantheon specific patches for epiphany
    # https://github.com/elementary/browser
    #
    # Patch to unlink nav buttons
    # https://github.com/elementary/browser/pull/18
    (fetchpatch {
      url = "https://raw.githubusercontent.com/elementary/browser/cc17559a7ac6effe593712b4f3d0bbefde6e3b62/navigation-buttons.patch";
      sha256 = "sha256-G1/JUjn/8DyO9sgL/5Kq205KbTOs4EMi4Vf3cJ8FHXU=";
    })
  ];

  nativeBuildInputs = [
    desktop-file-utils
    gettext
    itstool
    libxslt
    meson
    ninja
    pkg-config
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
    libportal-gtk3
    libnotify
    libarchive
    libsecret
    libsoup_3
    libxml2
    nettle
    p11-kit
    sqlite
    webkitgtk_4_1
  ];

  # Tests need an X display
  mesonFlags = [
    "-Dunit_tests=disabled"
  ];

  postPatch = ''
    chmod +x post_install.py # patchShebangs requires executable file
    patchShebangs post_install.py
  '';

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
