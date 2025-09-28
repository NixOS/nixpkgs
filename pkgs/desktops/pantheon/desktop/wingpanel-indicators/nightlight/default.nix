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
  libgee,
  libxml2,
}:

stdenv.mkDerivation rec {
  pname = "wingpanel-indicator-nightlight";
  version = "2.1.3";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "wingpanel-indicator-nightlight";
    rev = version;
    sha256 = "sha256-77+JGJ0/Y9UJwOuKfJAqjNnmZfBy/YiEwCybx6yoVwM=";
  };

  nativeBuildInputs = [
    libxml2
    meson
    ninja
    pkg-config
    vala
  ];

  buildInputs = [
    granite
    gtk3
    libgee
    wingpanel
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Night Light Indicator for Wingpanel";
    homepage = "https://github.com/elementary/wingpanel-indicator-nightlight";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    teams = [ teams.pantheon ];
  };
}
