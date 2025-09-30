{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  pkg-config,
  meson,
  ninja,
  vala,
  gtk3,
  granite,
  networkmanager,
  polkit,
  libnma,
  wingpanel,
  libgee,
}:

stdenv.mkDerivation rec {
  pname = "wingpanel-indicator-network";
  version = "8.0.0";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "wingpanel-indicator-network";
    rev = version;
    sha256 = "sha256-7zp/GwM+aSQie82asX6yFPSPUxtzeyxCwdr8DWc0LQk=";
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
    libgee
    networkmanager
    polkit
    libnma
    wingpanel
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Network Indicator for Wingpanel";
    homepage = "https://github.com/elementary/wingpanel-indicator-network";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    teams = [ teams.pantheon ];
  };
}
