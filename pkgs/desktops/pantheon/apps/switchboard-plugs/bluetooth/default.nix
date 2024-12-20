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
  granite7,
  gtk4,
  bluez,
  switchboard,
  wingpanel-indicator-bluetooth,
}:

stdenv.mkDerivation rec {
  pname = "switchboard-plug-bluetooth";
  version = "8.0.1";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "sha256-NefWnkI7K6I1JY3UG9wUbB/yF3R8tUdPb4tAafiTR3o=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    vala
  ];

  buildInputs = [
    bluez
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
    homepage = "https://github.com/elementary/switchboard-plug-bluetooth";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
  };

}
