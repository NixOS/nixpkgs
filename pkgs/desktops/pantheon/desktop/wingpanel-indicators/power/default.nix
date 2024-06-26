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
  gtk3,
  granite,
  bamf,
  libgtop,
  libnotify,
  udev,
  wingpanel,
  libgee,
}:

stdenv.mkDerivation rec {
  pname = "wingpanel-indicator-power";
  version = "6.2.1";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "sha256-EEY32O7GeXBHSjZQ3XGogT1sUzIKGX+CzcGx8buGLq4=";
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
    bamf
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
