{
  lib,
  stdenv,
  fetchurl,
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
  mateUpdateScript,
}:

stdenv.mkDerivation rec {
  pname = "eom";
  version = "1.28.0";

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "mgHKsplaGoxyWMhl6uXxgu1HMMRGcq/cOgfkI+3VOrw=";
  };

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
