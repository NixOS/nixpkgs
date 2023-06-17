{ lib
, stdenv
, fetchFromGitHub
, nix-update-script
, meson
, ninja
, pkg-config
, vala
, evolution-data-server
, glib
, granite
, gtk3
, libhandy
, switchboard
}:

stdenv.mkDerivation rec {
  pname = "switchboard-plug-onlineaccounts";
  version = "6.5.2";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "sha256-IW6twvEbCzQbuNFnryHxer5rK5zYfbmilcLjHCV9ZsM=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    vala
  ];

  buildInputs = [
    evolution-data-server
    glib
    granite
    gtk3
    libhandy
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
