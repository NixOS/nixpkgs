{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  meson,
  ninja,
  sassc,
  vala,
  pkg-config,
  libgee,
  libshumate,
  gtk4,
  glib,
  gettext,
  gsettings-desktop-schemas,
  gobject-introspection,
  wrapGAppsHook4,
}:

stdenv.mkDerivation rec {
  pname = "granite";
  version = "7.7.0";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "granite";
    rev = version;
    sha256 = "sha256-ypSkzz9BaVweR1C0OkkfwDl8tehMK1S5iExL14LuKmI=";
  };

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

  buildInputs = [
    libshumate # demo
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
