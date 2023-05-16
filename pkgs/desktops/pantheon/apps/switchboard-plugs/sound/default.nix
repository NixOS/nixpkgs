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
, pulseaudio
, libcanberra-gtk3
, switchboard
}:

stdenv.mkDerivation rec {
  pname = "switchboard-plug-sound";
<<<<<<< HEAD
  version = "2.3.3";
=======
  version = "2.3.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-JXt/S+vNzuRaRC0DMX13Lxv+OoAPRQmSLv9fsvnkWY4=";
=======
    sha256 = "sha256-a3GYtV0f+I9grnwndGI782/shpUWpR6GrRRD380Q6+o=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    vala
  ];

  buildInputs = [
    granite
    gtk3
    libcanberra-gtk3
    libgee
<<<<<<< HEAD
    libhandy
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    pulseaudio
    switchboard
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Switchboard Sound Plug";
    homepage = "https://github.com/elementary/switchboard-plug-sound";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
  };
}
