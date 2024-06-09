{ lib
, stdenv
, fetchFromGitHub
, nix-update-script
, meson
, ninja
, pkg-config
, substituteAll
, vala
, libadwaita
, libgee
, granite7
, gtk4
, networkmanager
, networkmanagerapplet
, libnma-gtk4
, switchboard
}:

stdenv.mkDerivation rec {
  pname = "switchboard-plug-network";
  version = "2.5.0-unstable-2024-05-05";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = "16ea3e892edb7bfad806bd7138d55801ff72e119";
    hash = "sha256-3dbDsMhFPnOG7P5oviv9dcGgEcXtH3RJPaubCYGx8Kw=";
  };

  patches = [
    (substituteAll {
      src = ./fix-paths.patch;
      inherit networkmanagerapplet;
    })
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    vala
  ];

  buildInputs = [
    granite7
    gtk4
    libadwaita
    libgee
    networkmanager
    libnma-gtk4
    switchboard
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Switchboard Networking Plug";
    homepage = "https://github.com/elementary/switchboard-plug-network";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
  };
}
