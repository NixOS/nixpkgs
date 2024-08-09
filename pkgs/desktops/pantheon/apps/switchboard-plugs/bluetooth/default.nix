{ lib
, stdenv
, fetchFromGitHub
, nix-update-script
, meson
, ninja
, pkg-config
, vala
, libadwaita
, libgee
, granite7
, gtk4
, bluez
, switchboard
, wingpanel-indicator-bluetooth
}:

stdenv.mkDerivation rec {
  pname = "switchboard-plug-bluetooth";
  version = "2.3.6-unstable-2024-05-04";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = "e22627e924312261611760c458a6ee5495d39549";
    sha256 = "sha256-7bIKbaP+Oai8D5iVwGjjo2aXbBjmW5yA5PZepGZXOYg=";
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
