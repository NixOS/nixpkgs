{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  replaceVars,
  pkg-config,
  meson,
  ninja,
  vala,
  gtk3,
  granite,
  wingpanel,
  evolution-data-server,
  libical,
  libgee,
  libhandy,
  libxml2,
  elementary-calendar,
}:

stdenv.mkDerivation rec {
  pname = "wingpanel-indicator-datetime";
  version = "2.4.2";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "wingpanel-indicator-datetime";
    rev = version;
    sha256 = "sha256-iR80pF3KUe0WboFm2/f1ZK9/wER2LfmRBd92e8jGTHs=";
  };

  patches = [
    (replaceVars ./fix-paths.patch {
      elementary_calendar = elementary-calendar;
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
    evolution-data-server
    granite
    gtk3
    libgee
    libhandy
    libical
    wingpanel
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Date & Time Indicator for Wingpanel";
    homepage = "https://github.com/elementary/wingpanel-indicator-datetime";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    teams = [ teams.pantheon ];
  };
}
