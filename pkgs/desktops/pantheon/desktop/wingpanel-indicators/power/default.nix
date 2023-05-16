{ lib
, stdenv
, fetchFromGitHub
, substituteAll
, nix-update-script
, gnome-power-manager
, pkg-config
, meson
<<<<<<< HEAD
=======
, python3
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, ninja
, vala
, gtk3
, granite
, bamf
, libgtop
, libnotify
, udev
, wingpanel
, libgee
}:

stdenv.mkDerivation rec {
  pname = "wingpanel-indicator-power";
<<<<<<< HEAD
  version = "6.2.1";
=======
  version = "6.2.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-EEY32O7GeXBHSjZQ3XGogT1sUzIKGX+CzcGx8buGLq4=";
=======
    sha256 = "sha256-TxrskbwitsilTidWifSWg9IP6BzH1y/OOrFohlENJmM=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  patches = [
    (substituteAll {
      src = ./fix-paths.patch;
      gnome_power_manager = gnome-power-manager;
    })
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
<<<<<<< HEAD
=======
    python3
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    vala
  ];

  buildInputs = [
    bamf
    granite
    gtk3
    libgee
    libgtop
    libnotify
    udev
    wingpanel
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
    description = "Power Indicator for Wingpanel";
    homepage = "https://github.com/elementary/wingpanel-indicator-power";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
  };
}
