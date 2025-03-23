{
  lib,
  stdenv,
  fetchFromGitHub,
  unstableGitUpdater,
  replaceVars,
  meson,
  ninja,
  pkg-config,
  vala,
  gtk3,
  libindicator-gtk3,
  pantheon,
  indicator-application-gtk3,
}:

stdenv.mkDerivation rec {
  pname = "wingpanel-indicator-ayatana";
  version = "2.0.7-unstable-2023-04-18";

  src = fetchFromGitHub {
    owner = "Lafydev";
    repo = pname;
    rev = "d554663b4e199d44c1f1d53b5cc39b9a775b3f1c";
    sha256 = "sha256-dEk0exLh+TGuQt7be2YRTS2EzPD55+edR8WibthXwhI=";
  };

  patches = [
    # Tells the indicator the path for libapplication.so
    (replaceVars ./fix-libapplication-dir.patch {
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
