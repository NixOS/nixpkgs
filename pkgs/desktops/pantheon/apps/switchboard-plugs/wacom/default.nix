{ lib
, stdenv
, fetchFromGitHub
, nix-update-script
, meson
, ninja
, pkg-config
, vala
, glib
, granite7
, gtk4
, libadwaita
, libgee
, libgudev
, libwacom
, switchboard
, xorg
}:

stdenv.mkDerivation rec {
  pname = "switchboard-plug-wacom";
  version = "8.0.0";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "sha256-Ct+1n/GmrS9xi8QIJDWKfwNL1kvNz3o+0tsxLZtwjmI=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    vala
  ];

  buildInputs = [
    glib
    granite7
    gtk4
    libadwaita
    libgee
    libgudev
    libwacom
    switchboard
    xorg.libX11
    xorg.libXi
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Switchboard Wacom Plug";
    homepage = "https://github.com/elementary/switchboard-plug-wacom";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
  };
}
