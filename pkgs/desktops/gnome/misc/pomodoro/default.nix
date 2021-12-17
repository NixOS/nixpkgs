{ lib
, stdenv
, fetchFromGitHub
, substituteAll
, fetchpatch
, meson
, ninja
, pkg-config
, wrapGAppsHook
, desktop-file-utils
, libcanberra
, gst_all_1
, vala
, gtk3
, gom
, sqlite
, libxml2
, glib
, gobject-introspection
, libpeas
, gsettings-desktop-schemas
, gettext
}:

stdenv.mkDerivation rec {
  pname = "gnome-shell-pomodoro";
  version = "0.20.0";

  src = fetchFromGitHub {
    owner = "gnome-pomodoro";
    repo = "gnome-pomodoro";
    rev = version;
    sha256 = "sha256-USzLHoBM0QbBPtbTzJJY02cOSDtmlxPGYhMj7M1FJic=";
  };

  patches = [
    # Our glib setup hooks moves GSettings schemas to a subdirectory to prevent conflicts.
    # We need to patch the build script so that the extension can find them.
    (substituteAll {
      src = ./fix-schema-path.patch;
      inherit pname version;
    })

    # Fix error reporting code.
    # https://github.com/gnome-pomodoro/gnome-pomodoro/pull/591
    (fetchpatch {
      url = "https://github.com/gnome-pomodoro/gnome-pomodoro/commit/133bd62f15653856d9705b66188b42c20d81719e.patch";
      sha256 = "A20K+57A6/lYH2Buri2+wrCQgz6EGBdYg2xQbHPSkYc=";
    })
  ];

  nativeBuildInputs = [
    meson
    ninja
    gettext
    gobject-introspection
    libxml2
    pkg-config
    vala
    wrapGAppsHook
    desktop-file-utils
  ];

  buildInputs = [
    glib
    gom
    gsettings-desktop-schemas
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gstreamer
    gtk3
    libcanberra
    libpeas
    sqlite
  ];

  meta = with lib; {
    homepage = "https://gnomepomodoro.org/";
    description = "Time management utility for GNOME based on the pomodoro technique";
    longDescription = ''
      This GNOME utility helps to manage time according to Pomodoro Technique.
      It intends to improve productivity and focus by taking short breaks.
    '';
    maintainers = with maintainers; [ ];
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
