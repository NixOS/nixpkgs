{ lib
, stdenv
, fetchFromGitHub
, unstableGitUpdater
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
  version = "unstable-2021-12-18";

  src = fetchFromGitHub {
    owner = "Lafydev";
    repo = pname;
    rev = "5749f753ca64ce58232a46b9045949b3f8219827";
    sha256 = "sha256-kuEVw62IDTyC3hRRcWv2RihPOohGqEt8YLr44SurwPM=";
  };

  patches = [
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

  passthru = {
    updateScript = unstableGitUpdater {
      url = "https://github.com/Lafydev/wingpanel-indicator-ayatana.git";
    };
  };

  meta = with lib; {
    description = "Ayatana Compatibility Indicator for Wingpanel";
    homepage = "https://github.com/Lafydev/wingpanel-indicator-ayatana";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
  };
}
