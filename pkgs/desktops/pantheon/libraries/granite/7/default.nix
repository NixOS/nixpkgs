{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  nix-update-script,
  meson,
  ninja,
  sassc,
  vala,
  pkg-config,
  libgee,
  gtk4,
  glib,
  gettext,
  gsettings-desktop-schemas,
  gobject-introspection,
  wrapGAppsHook4,
}:

stdenv.mkDerivation rec {
  pname = "granite";
  version = "7.6.0";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "granite";
    rev = version;
    sha256 = "sha256-bv2rOq16xg9lCWfcLzAFN4LjBTJBxPhXvEJzutkdYzs=";
  };

  patches = [
    # Init: Avoid crash with Gtk >= 4.17
    # https://github.com/elementary/granite/pull/893
    (fetchpatch {
      url = "https://github.com/elementary/granite/commit/60cb8c4119b579592e6c7f3b1476e4d729f58699.patch";
      hash = "sha256-6NB/Tu3mdmiBd77SOi4twdY/HidyhMn7mNN+54iFLIc=";
    })
  ];

  nativeBuildInputs = [
    gettext
    gobject-introspection
    meson
    ninja
    pkg-config
    sassc
    vala
    wrapGAppsHook4
  ];

  propagatedBuildInputs = [
    glib
    gsettings-desktop-schemas # is_clock_format_12h uses "org.gnome.desktop.interface clock-format"
    gtk4
    libgee
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Extension to GTK used by elementary OS";
    longDescription = ''
      Granite is a companion library for GTK and GLib. Among other things, it provides complex widgets and convenience functions
      designed for use in apps built for elementary OS.
    '';
    homepage = "https://github.com/elementary/granite";
    license = licenses.lgpl3Plus;
    platforms = platforms.linux;
    teams = [ teams.pantheon ];
    mainProgram = "granite-7-demo";
  };
}
