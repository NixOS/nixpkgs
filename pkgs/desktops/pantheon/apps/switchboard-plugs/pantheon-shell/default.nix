{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  meson,
  ninja,
  pkg-config,
  vala,
  glib,
  libadwaita,
  libgee,
  granite7,
  gexiv2,
  gnome-settings-daemon,
  elementary-settings-daemon,
  gtk4,
  gala,
  wingpanel,
  wingpanel-indicator-keyboard,
  wingpanel-quick-settings,
  switchboard,
  gettext,
}:

stdenv.mkDerivation rec {
  pname = "switchboard-plug-pantheon-shell";
  version = "8.2.0";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "settings-desktop";
    rev = version;
    sha256 = "sha256-TYwiL6+VjfSDiFAlMe482gB8a/OtCYHl5r8gh9Hcvfg=";
  };

  nativeBuildInputs = [
    gettext
    meson
    ninja
    pkg-config
    vala
  ];

  buildInputs = [
    elementary-settings-daemon
    gnome-settings-daemon
    gala
    gexiv2
    glib
    granite7
    gtk4
    libadwaita
    libgee
    switchboard
    wingpanel
    wingpanel-indicator-keyboard # gsettings schemas
    wingpanel-quick-settings # gsettings schemas
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Switchboard Desktop Plug";
    homepage = "https://github.com/elementary/settings-desktop";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    teams = [ teams.pantheon ];
  };
}
