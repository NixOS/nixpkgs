{
  lib,
  stdenv,
  fetchFromGitHub,
  substituteAll,
  nix-update-script,
  gnome-power-manager,
  pkg-config,
  meson,
  ninja,
  vala,
  elementary-settings-daemon,
  gtk3,
  granite,
  libgtop,
  libnotify,
  udev,
  wingpanel,
  libgee,
}:

stdenv.mkDerivation rec {
  pname = "wingpanel-indicator-power";
  version = "8.0.1";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "sha256-zMvw96uRr9hrgXck+OhMiPku9qu8/zUtusiaJLUcuys=";
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
    vala
  ];

  buildInputs = [
    elementary-settings-daemon
    granite
    gtk3
    libgee
    libgtop
    libnotify
    udev
    wingpanel
  ];

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
