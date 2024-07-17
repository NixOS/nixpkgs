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
  wingpanel,
  accountsservice,
  libgee,
  libhandy,
}:

stdenv.mkDerivation rec {
  pname = "wingpanel-indicator-session";
  version = "2.3.1";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "sha256-2AEMe5dctTicW1MiGRV1SMjN/uFxQGbOYzCNFS1/KNk=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    vala
  ];

  buildInputs = [
    accountsservice
    granite
    gtk3
    libgee
    libhandy
    wingpanel
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Session Indicator for Wingpanel";
    homepage = "https://github.com/elementary/wingpanel-indicator-session";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
  };
}
