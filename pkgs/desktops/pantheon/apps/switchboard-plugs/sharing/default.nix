{ lib
, stdenv
, fetchFromGitHub
, nix-update-script
, meson
, ninja
, pkg-config
, vala
, libgee
, granite7
, gtk4
, switchboard
}:

stdenv.mkDerivation rec {
  pname = "switchboard-plug-sharing";
  version = "2.1.6-unstable-2024-05-05";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = "1d69fcc46c7d193696dc1a89f28a94e1d8a25873";
    sha256 = "sha256-50LMUv/TLK8sTWuk+ZQasQNxy92Ap5yCgnhNHDgMFOY=";
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
    libgee
    switchboard
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Switchboard Sharing Plug";
    homepage = "https://github.com/elementary/switchboard-plug-sharing";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
  };
}
