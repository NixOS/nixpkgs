{ lib
, stdenv
, fetchFromGitHub
, nix-update-script
, meson
, ninja
, substituteAll
, pkg-config
, vala
, libadwaita
, libgee
, granite7
, gtk4
, libxml2
, switchboard
, tzdata
}:

stdenv.mkDerivation rec {
  pname = "switchboard-plug-datetime";
  version = "2.2.0-unstable-2024-04-26";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = "29d0c3b4d58d2cf13ddf47ef9984d6aaf52b518a";
    sha256 = "sha256-p6ocJrW9aGzVxVY7i/IV71w/QBnG4NztgCYFHMnbLgk=";
  };

  patches = [
    (substituteAll {
      src = ./fix-paths.patch;
      tzdata = tzdata;
    })
  ];

  nativeBuildInputs = [
    libxml2
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
    switchboard
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Switchboard Date & Time Plug";
    homepage = "https://github.com/elementary/switchboard-plug-datetime";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
  };
}
