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
, switchboard
}:

stdenv.mkDerivation rec {
  pname = "switchboard-plug-display";
  version = "7.0.0-unstable-2024-05-05";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = "58627fa60406cfb437428dea1a45a3ee34018b7a";
    sha256 = "sha256-7ULCSzIzj2A1XH8neSm8YQunMTtWwIYL6I6TMkQw5mE=";
  };

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
    switchboard
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Switchboard Displays Plug";
    homepage = "https://github.com/elementary/switchboard-plug-display";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
  };
}
