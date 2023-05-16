{ lib
, stdenv
, fetchFromGitHub
, nix-update-script
, meson
, ninja
, pkg-config
, vala
, wrapGAppsHook4
, glib
, granite7
, gtk4
, systemd
, xorg
}:

stdenv.mkDerivation rec {
  pname = "xdg-desktop-portal-pantheon";
<<<<<<< HEAD
  version = "7.1.1";
=======
  version = "7.0.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "portals";
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-JZ2VYsNAjNGCzKOEhHCZx2uNLHFs+ktjFmROLHdFjX4=";
=======
    sha256 = "sha256-Rfo9Z5rCJgk36Db3ce8dYBJswy8owjvRMrJVB/RfwyI=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    vala
    wrapGAppsHook4
  ];

  buildInputs = [
    glib
    granite7
    gtk4
    systemd
    xorg.libX11
  ];

  mesonFlags = [
    "-Dsystemduserunitdir=${placeholder "out"}/lib/systemd/user"
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Backend implementation for xdg-desktop-portal for the Pantheon desktop environment";
    homepage = "https://github.com/elementary/portals";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
  };
}
