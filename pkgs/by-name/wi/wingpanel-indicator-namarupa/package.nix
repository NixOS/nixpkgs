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
  libgee,
  libindicator-gtk3,
  pantheon,
  indicator-application-gtk3,
}:

stdenv.mkDerivation {
  pname = "wingpanel-indicator-namarupa";
  version = "0.0.0-unstable-2024-12-17";

  src = fetchFromGitHub {
    owner = "lenemter";
    repo = "wingpanel-indicator-namarupa";
    rev = "d9fc4e47d58c72e0cf08aa11246910ce84fcef50";
    sha256 = "sha256-8jzhrCMkP5ui964JRZUs+tl2ShxeB8q60fBUI4okrpg=";
  };

  patches = [
    # Tells the indicator the path for libapplication.so
    (replaceVars ./fix-meson-build.patch {
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
    libgee
    libindicator-gtk3
    pantheon.granite
    pantheon.wingpanel
  ];

  passthru = {
    updateScript = unstableGitUpdater {
      url = "https://github.com/lenemter/wingpanel-indicator-namarupa.git";
    };
  };

  meta = with lib; {
    description = "Wingpanel Namarupa Indicator (Ayatana support)";
    homepage = "https://github.com/lenemter/wingpanel-indicator-namarupa";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    teams = [ teams.pantheon ];
  };
}
