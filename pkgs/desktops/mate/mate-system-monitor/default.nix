{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  gettext,
  itstool,
  gtkmm3,
  libxml2,
  libgtop,
  librsvg,
  polkit,
  systemd,
  wrapGAppsHook3,
  mate-desktop,
<<<<<<< HEAD
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
=======
  mateUpdateScript,
}:

stdenv.mkDerivation rec {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pname = "mate-system-monitor";
  version = "1.28.1";

  src = fetchurl {
<<<<<<< HEAD
    url = "https://pub.mate-desktop.org/releases/${lib.versions.majorMinor finalAttrs.version}/mate-system-monitor-${finalAttrs.version}.tar.xz";
=======
    url = "https://pub.mate-desktop.org/releases/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    sha256 = "QtZj1rkPtTYevBP2VHmD1vHirHXcKuTxysbqYymWWiU=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    pkg-config
    gettext
    itstool
    libxml2 # xmllint
    wrapGAppsHook3
  ];

  buildInputs = [
    gtkmm3
    libxml2
    libgtop
    librsvg
    polkit
    systemd
  ];

  postPatch = ''
    # This package does not provide mate-version.xml.
    substituteInPlace src/sysinfo.cpp \
      --replace-fail 'DATADIR "/mate-about/mate-version.xml"' '"${mate-desktop}/share/mate-about/mate-version.xml"'
  '';

  enableParallelBuilding = true;

<<<<<<< HEAD
  passthru.updateScript = gitUpdater {
    url = "https://git.mate-desktop.org/mate-system-monitor";
    odd-unstable = true;
    rev-prefix = "v";
  };

  meta = {
    description = "System monitor for the MATE desktop";
    mainProgram = "mate-system-monitor";
    homepage = "https://mate-desktop.org";
    license = [ lib.licenses.gpl2Plus ];
    platforms = lib.platforms.unix;
    teams = [ lib.teams.mate ];
  };
})
=======
  passthru.updateScript = mateUpdateScript { inherit pname; };

  meta = with lib; {
    description = "System monitor for the MATE desktop";
    mainProgram = "mate-system-monitor";
    homepage = "https://mate-desktop.org";
    license = [ licenses.gpl2Plus ];
    platforms = platforms.unix;
    teams = [ teams.mate ];
  };
}
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
