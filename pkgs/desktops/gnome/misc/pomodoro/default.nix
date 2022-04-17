{ lib
, stdenv
, fetchFromGitHub
, substituteAll
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
, cairo
, json-glib
}:

stdenv.mkDerivation rec {
  pname = "gnome-shell-pomodoro";
  version = "0.21.0";

  src = fetchFromGitHub {
    owner = "gnome-pomodoro";
    repo = "gnome-pomodoro";
    rev = version;
    sha256 = "sha256-LJpS6eAlfeDIehRCD9jBjzd5zjlRhBn8Oc6ZREkwOkA=";
  };

  patches = [
    # Our glib setup hooks moves GSettings schemas to a subdirectory to prevent conflicts.
    # We need to patch the build script so that the extension can find them.
    (substituteAll {
      src = ./fix-schema-path.patch;
      inherit pname version;
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
    cairo
    glib
    gom
    gsettings-desktop-schemas
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gstreamer
    gtk3
    json-glib
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
