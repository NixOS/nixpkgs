{ lib
, stdenv
, fetchFromGitHub
, nix-update-script
, meson
, ninja
, pkg-config
, substituteAll
, vala
, libgee
, granite
, gtk3
, networkmanager
, networkmanagerapplet
, libnma
, switchboard
}:

stdenv.mkDerivation rec {
  pname = "switchboard-plug-network";
  version = "2.4.3";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "sha256-g0EvdYwgs+5l3wFKhQbf9o8iUr6NOvBqv+VM6xYThPA=";
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
    granite
    gtk3
    libgee
    networkmanager
    libnma
    switchboard
  ];

  passthru = {
    updateScript = nix-update-script {
      attrPath = "pantheon.${pname}";
    };
  };

  meta = with lib; {
    description = "Switchboard Networking Plug";
    homepage = "https://github.com/elementary/switchboard-plug-network";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
  };
}
