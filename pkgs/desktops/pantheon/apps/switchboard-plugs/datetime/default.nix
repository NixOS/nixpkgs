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
  version = "8.0.0";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "sha256-PE1ig8p9H4MfipIpN3ubXAJNzLwGVW89adn+SF3rEuQ=";
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
