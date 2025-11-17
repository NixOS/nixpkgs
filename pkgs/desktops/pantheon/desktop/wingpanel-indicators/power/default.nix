{
  lib,
  stdenv,
  fetchFromGitHub,
  replaceVars,
  nix-update-script,
  gnome-power-manager,
  pkg-config,
  meson,
  ninja,
  vala,
  elementary-settings-daemon,
  gettext,
  gtk3,
  granite,
  libgtop,
  libnotify,
  udev,
  wingpanel,
  libgee,
}:

stdenv.mkDerivation rec {
  pname = "wingpanel-indicator-power";
  version = "8.0.2";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "wingpanel-indicator-power";
    rev = version;
    sha256 = "sha256-AeeL/OcQ7V3HT3IWhTQHx/dcCSqL/0s/fShPq96V3xE=";
  };

  patches = [
    (replaceVars ./fix-paths.patch {
      gnome_power_manager = gnome-power-manager;
    })
  ];

  nativeBuildInputs = [
    gettext # msgfmt
    meson
    ninja
    pkg-config
    vala
  ];

  buildInputs = [
    elementary-settings-daemon
    granite
    gtk3
    libgee
    libgtop
    libnotify
    udev
    wingpanel
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Power Indicator for Wingpanel";
    homepage = "https://github.com/elementary/wingpanel-indicator-power";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    teams = [ teams.pantheon ];
  };
}
