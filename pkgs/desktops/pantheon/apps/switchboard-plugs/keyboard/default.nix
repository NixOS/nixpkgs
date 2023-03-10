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
  version = "3.1.1";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "sha256-DofAOv7sCe7RAJpgz9PEYm+C8RAl0a1KgFm9jToMsEY=";
  };

  patches = [
    ./0001-Remove-Install-Unlisted-Engines-function.patch
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
