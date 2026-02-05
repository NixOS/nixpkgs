{
  lib,
  stdenv,
  fetchFromGitHub,
  autoconf-archive,
  autoreconfHook,
  gtk-doc,
  mate-common,
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
  yelp-tools,
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "eom";
  version = "1.28.1";

  src = fetchFromGitHub {
    owner = "mate-desktop";
    repo = "eom";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2MO8z30Styv5vAnNVFpETAZtZ+LMbgBSDq1mUQZ9X1c=";
  };

  nativeBuildInputs = [
    autoconf-archive
    autoreconfHook
    gtk-doc
    mate-common # mate-common.m4 macros
    pkg-config
    gettext
    itstool
    wrapGAppsHook3
    yelp-tools
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

  passthru.updateScript = gitUpdater {
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
