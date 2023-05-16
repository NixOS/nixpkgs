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
<<<<<<< HEAD
  version = "6.5.3";
=======
  version = "6.5.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-qERXF7aymI2xbyqrD6rwUBiFNRnIiVllavSPgW0F8yk=";
=======
    sha256 = "sha256-IW6twvEbCzQbuNFnryHxer5rK5zYfbmilcLjHCV9ZsM=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
