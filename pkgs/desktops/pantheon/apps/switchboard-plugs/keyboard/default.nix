{ lib
, stdenv
, fetchFromGitHub
, nix-update-script
, substituteAll
, meson
, ninja
, pkg-config
, vala
, libgee
, gnome-settings-daemon
, granite
, gsettings-desktop-schemas
, gtk3
, libhandy
, libxml2
, libgnomekbd
, libxklavier
, ibus
, onboard
, switchboard
}:

stdenv.mkDerivation rec {
  pname = "switchboard-plug-keyboard";
<<<<<<< HEAD
  version = "3.2.1";
=======
  version = "3.1.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-4LfS2F8pLbZw+HhnEVmZqbEaNCM96q+lqnf4sUBDVJI=";
  };

  patches = [
    # This will try to install packages with apt.
    # https://github.com/elementary/switchboard-plug-keyboard/issues/324
    ./hide-install-unlisted-engines-button.patch

=======
    sha256 = "sha256-DofAOv7sCe7RAJpgz9PEYm+C8RAl0a1KgFm9jToMsEY=";
  };

  patches = [
    ./0001-Remove-Install-Unlisted-Engines-function.patch
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    (substituteAll {
      src = ./fix-paths.patch;
      inherit ibus onboard libgnomekbd;
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
    gnome-settings-daemon # media-keys
    granite
    gsettings-desktop-schemas
    gtk3
    ibus
    libgee
    libhandy
    libxklavier
    switchboard
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Switchboard Keyboard Plug";
    homepage = "https://github.com/elementary/switchboard-plug-keyboard";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
  };
}
