{ lib, stdenv
, fetchFromGitHub
, nix-update-script
, pantheon
, pkg-config
, meson
, ninja
, vala
, gtk3
, granite
, wingpanel
, libgee
, libhandy
, elementary-notifications
}:

stdenv.mkDerivation rec {
  pname = "wingpanel-indicator-notifications";
  version = "6.0.2";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "sha256-ZuOZlfxtRq8ZcrXGe9wlFGwn2isdvMoXQveKKnEPFdo=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    vala
  ];

  buildInputs = [
    elementary-notifications
    granite
    gtk3
    libgee
    libhandy
    wingpanel
  ];

  passthru = {
    updateScript = nix-update-script {
      attrPath = "pantheon.${pname}";
    };
  };

  meta = with lib; {
    description = "Notifications Indicator for Wingpanel";
    homepage = "https://github.com/elementary/wingpanel-indicator-notifications";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
  };
}
