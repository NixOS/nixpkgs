{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  meson,
  ninja,
  pkg-config,
  vala,
  accountsservice,
  dbus,
  desktop-file-utils,
  fwupd,
  gdk-pixbuf,
  geoclue2,
  gexiv2,
  glib,
  gnome-settings-daemon,
  gobject-introspection,
  gtk3,
  granite,
  libgee,
  packagekit,
  systemd,
  wrapGAppsHook3,
}:

stdenv.mkDerivation rec {
  pname = "elementary-settings-daemon";
  version = "8.4.0";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "settings-daemon";
    rev = version;
    sha256 = "sha256-VdvwrkafZJ0+z2MYWT83POdo8dZrSAOL5RhAiwGEc2g=";
  };

  nativeBuildInputs = [
    desktop-file-utils
    gobject-introspection
    meson
    ninja
    pkg-config
    vala
    wrapGAppsHook3
  ];

  buildInputs = [
    accountsservice
    dbus
    fwupd
    gdk-pixbuf
    geoclue2
    gexiv2
    glib
    gnome-settings-daemon # org.gnome.settings-daemon.* gschema
    gtk3
    granite
    libgee
    packagekit
    systemd
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Settings daemon for Pantheon";
    homepage = "https://github.com/elementary/settings-daemon";
    license = licenses.gpl3Plus;
    teams = [ teams.pantheon ];
    platforms = platforms.linux;
    mainProgram = "io.elementary.settings-daemon";
  };
}
