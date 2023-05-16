{ lib
, stdenv
, fetchFromGitHub
, nix-update-script
, meson
, ninja
, pkg-config
<<<<<<< HEAD
=======
, python3
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, vala
, wrapGAppsHook4
, appcenter
, elementary-settings-daemon
, glib
, granite7
, gtk4
, libadwaita
, libgee
}:

stdenv.mkDerivation rec {
  pname = "elementary-onboarding";
<<<<<<< HEAD
  version = "7.2.0";
=======
  version = "7.1.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "onboarding";
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-5vEKQUGg5KQSheM6tSK8uieEfCqlY6pABfPb/333FHU=";
=======
    sha256 = "sha256-OWALEcVOOh7wjEEvysd+MQhB/iK3105XCIVp5pklMwY=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
<<<<<<< HEAD
=======
    python3
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    vala
    wrapGAppsHook4
  ];

  buildInputs = [
    appcenter # settings schema
    elementary-settings-daemon # settings schema
    glib
    granite7
    gtk4
    libadwaita
    libgee
  ];

<<<<<<< HEAD
=======
  postPatch = ''
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py
  '';

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Onboarding app for new users designed for elementary OS";
    homepage = "https://github.com/elementary/onboarding";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
    mainProgram = "io.elementary.onboarding";
  };
}
