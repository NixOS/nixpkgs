{ lib
, stdenv
, fetchFromGitHub
, substituteAll
, meson
, ninja
, pkg-config
, vala
, gtk3
, libindicator-gtk3
, pantheon
, indicator-application-gtk3
}:

stdenv.mkDerivation rec {
  pname = "wingpanel-indicator-ayatana";
  version = "unstable-2021-12-01";

  src = fetchFromGitHub {
    owner = "Lafydev";
    repo = pname;
    rev = "53dc05919cdba772c787620a4bee5821e38c53cd";
    sha256 = "sha256-T0OHzqENyeAr0pvXUaRMwF1RpwKVyDAF5P5G9S28COU=";
  };

  patches = [
    # Fixes install path for wingpanel indicator
    # https://github.com/Lafydev/wingpanel-indicator-ayatana/pull/30
    ./fix-indicator-dir.patch
    # Tells the indicator the path for libapplication.so
    (substituteAll {
      src = ./fix-libapplication-dir.patch;
      indicator_application = indicator-application-gtk3;
    })
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    vala
  ];

  buildInputs = [
    gtk3
    libindicator-gtk3
    pantheon.granite
    pantheon.wingpanel
  ];

  meta = with lib; {
    description = "Ayatana Compatibility Indicator for Wingpanel";
    homepage = "https://github.com/Lafydev/wingpanel-indicator-ayatana";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
  };
}
