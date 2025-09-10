{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  meson,
  ninja,
  pkg-config,
  vala,
  libadwaita,
  libgee,
  gettext,
  granite7,
  gtk4,
  bluez,
  elementary-bluetooth-daemon,
  switchboard,
  wingpanel-indicator-bluetooth,
}:

stdenv.mkDerivation rec {
  pname = "switchboard-plug-bluetooth";
  version = "8.0.2";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "settings-bluetooth";
    rev = version;
    hash = "sha256-D2kigdGdmDtFWt/hldzHm+QqlGl6RBExhcdurLtCM1Q=";
  };

  nativeBuildInputs = [
    gettext # msgfmt
    meson
    ninja
    pkg-config
    vala
  ];

  buildInputs = [
    bluez
    elementary-bluetooth-daemon # settings schema
    granite7
    gtk4
    libadwaita
    libgee
    switchboard
    wingpanel-indicator-bluetooth # settings schema
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Switchboard Bluetooth Plug";
    homepage = "https://github.com/elementary/settings-bluetooth";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    teams = [ teams.pantheon ];
  };

}
