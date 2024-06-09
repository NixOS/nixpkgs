{ lib
, stdenv
, fetchFromGitHub
, nix-update-script
, meson
, ninja
, pkg-config
, vala
, evolution-data-server-gtk4
, glib
, granite7
, gtk4
, libadwaita
, switchboard
}:

stdenv.mkDerivation rec {
  pname = "switchboard-plug-onlineaccounts";
  version = "6.5.3-unstable-2024-05-04";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = "42f38c66fc7db56ee3eaa78d4f0384519c7b23c7";
    sha256 = "sha256-1Xmu0m/RhkIV+XeqgbZwfF7ZP3BrPsGY0LuVfqAsL6A=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    vala
  ];

  buildInputs = [
    evolution-data-server-gtk4
    glib
    granite7
    gtk4
    libadwaita
    switchboard
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Switchboard Online Accounts Plug";
    homepage = "https://github.com/elementary/switchboard-plug-onlineaccounts";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
  };
}
