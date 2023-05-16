{ lib
, stdenv
, fetchFromGitHub
, nix-update-script
, meson
, ninja
, pkg-config
, vala
, libgee
<<<<<<< HEAD
, libhandy
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, granite
, gtk3
, switchboard
, flatpak
}:

stdenv.mkDerivation rec {
  pname = "switchboard-plug-applications";
<<<<<<< HEAD
  version = "7.0.1";
=======
  version = "6.0.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-r2JKiTewsLQSZPriC0w72CFevRQXytrFcO2VfA9BKHA=";
=======
    sha256 = "18izmzhqp6x5ivha9yl8gyz9adyrsylw7w5p0cwm1bndgqbi7yh5";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    vala
  ];

  buildInputs = [
    flatpak
    granite
    gtk3
    libgee
<<<<<<< HEAD
    libhandy
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    switchboard
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Switchboard Applications Plug";
    homepage = "https://github.com/elementary/switchboard-plug-applications";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
  };
}
