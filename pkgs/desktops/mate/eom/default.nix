{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  pkg-config,
  gettext,
  itstool,
  exempi,
  lcms2,
  libexif,
  libjpeg,
  librsvg,
  libxml2,
  libpeas,
  shared-mime-info,
  gtk3,
  mate-desktop,
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
  pname = "eom";
  version = "1.28.0";

  src = fetchurl {
<<<<<<< HEAD
    url = "https://pub.mate-desktop.org/releases/${lib.versions.majorMinor finalAttrs.version}/eom-${finalAttrs.version}.tar.xz";
=======
    url = "https://pub.mate-desktop.org/releases/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    sha256 = "mgHKsplaGoxyWMhl6uXxgu1HMMRGcq/cOgfkI+3VOrw=";
  };

  patches = [
    # Switch to girepository-2.0
    (fetchpatch {
      url = "https://src.fedoraproject.org/rpms/eom/raw/84b45dc6302f378926be390d39a7cca3ec4f26ea/f/libpeas1_pygobject352.patch";
      hash = "sha256-HcwWXAnVzz5uuAz8Mljci2FA72TZJTD28qLvczXVtZU=";
    })
  ];

  nativeBuildInputs = [
    pkg-config
    gettext
    itstool
    wrapGAppsHook3
  ];

  buildInputs = [
    exempi
    lcms2
    libexif
    libjpeg
    librsvg
    libxml2
    shared-mime-info
    gtk3
    libpeas
    mate-desktop
    hicolor-icon-theme
  ];

  enableParallelBuilding = true;

<<<<<<< HEAD
  passthru.updateScript = gitUpdater {
    url = "https://git.mate-desktop.org/eom";
    odd-unstable = true;
    rev-prefix = "v";
  };

  meta = {
    description = "Image viewing and cataloging program for the MATE desktop";
    mainProgram = "eom";
    homepage = "https://mate-desktop.org";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
    teams = [ lib.teams.mate ];
  };
})
=======
  passthru.updateScript = mateUpdateScript { inherit pname; };

  meta = with lib; {
    description = "Image viewing and cataloging program for the MATE desktop";
    mainProgram = "eom";
    homepage = "https://mate-desktop.org";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    teams = [ teams.mate ];
  };
}
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
