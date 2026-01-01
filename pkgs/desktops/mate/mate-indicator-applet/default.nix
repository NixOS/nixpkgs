{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  gettext,
  gtk3,
  libayatana-indicator,
  mate-panel,
  hicolor-icon-theme,
  wrapGAppsHook3,
<<<<<<< HEAD
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
=======
  mateUpdateScript,
}:

stdenv.mkDerivation rec {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pname = "mate-indicator-applet";
  version = "1.28.0";

  src = fetchurl {
<<<<<<< HEAD
    url = "https://pub.mate-desktop.org/releases/${lib.versions.majorMinor finalAttrs.version}/mate-indicator-applet-${finalAttrs.version}.tar.xz";
=======
    url = "https://pub.mate-desktop.org/releases/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    sha256 = "zrPXA5cKPlWNfNffCxwhceOvdSolSVrO0uIiwemtSc0=";
  };

  postPatch = ''
    # Find installed Unity & Ayatana (new-style) indicators
    substituteInPlace src/applet-main.c \
      --replace-fail '/usr/share' '/run/current-system/sw/share'
  '';

  nativeBuildInputs = [
    pkg-config
    gettext
    wrapGAppsHook3
  ];

  buildInputs = [
    gtk3
    libayatana-indicator
    mate-panel
    hicolor-icon-theme
  ];

  configureFlags = [ "--with-ayatana-indicators" ];

  enableParallelBuilding = true;

<<<<<<< HEAD
  passthru.updateScript = gitUpdater {
    url = "https://git.mate-desktop.org/mate-indicator-applet";
    odd-unstable = true;
    rev-prefix = "v";
  };

  meta = {
=======
  passthru.updateScript = mateUpdateScript { inherit pname; };

  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    homepage = "https://github.com/mate-desktop/mate-indicator-applet";
    description = "MATE panel indicator applet";
    longDescription = ''
      A small applet to display information from various applications
      consistently in the panel.

      The indicator applet exposes Ayatana Indicators in the MATE Panel.
      Ayatana Indicators are an initiative by Canonical to provide crisp and
      clean system and application status indication. They take the form of
      an icon and associated menu, displayed (usually) in the desktop panel.
      Existing indicators include the Message Menu, Battery Menu and Sound
      menu.
    '';
<<<<<<< HEAD
    license = with lib.licenses; [
      gpl3Plus
      lgpl2Plus
    ];
    platforms = lib.platforms.unix;
    teams = [ lib.teams.mate ];
  };
})
=======
    license = with licenses; [
      gpl3Plus
      lgpl2Plus
    ];
    platforms = platforms.unix;
    teams = [ teams.mate ];
  };
}
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
