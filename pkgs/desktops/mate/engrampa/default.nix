{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  gettext,
  itstool,
  libxml2,
  caja,
  gtk3,
  hicolor-icon-theme,
  json-glib,
  mate-desktop,
  wrapGAppsHook3,
<<<<<<< HEAD
  gitUpdater,
=======
  mateUpdateScript,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  # can be defaulted to true once switch to meson
  withMagic ? stdenv.buildPlatform.canExecute stdenv.hostPlatform,
  file,
}:

<<<<<<< HEAD
stdenv.mkDerivation (finalAttrs: {
=======
stdenv.mkDerivation rec {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pname = "engrampa";
  version = "1.28.2";

  src = fetchurl {
<<<<<<< HEAD
    url = "https://pub.mate-desktop.org/releases/${lib.versions.majorMinor finalAttrs.version}/engrampa-${finalAttrs.version}.tar.xz";
=======
    url = "https://pub.mate-desktop.org/releases/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    hash = "sha256-Hpl3wjdFv4hDo38xUXHZr5eBSglxrqw9d08BdlCsCe8=";
  };

  nativeBuildInputs = [
    pkg-config
    gettext
    itstool
    libxml2 # for xmllint
    wrapGAppsHook3
  ];

  buildInputs = [
    caja
    gtk3
    hicolor-icon-theme
    json-glib
    mate-desktop
  ]
  ++ lib.optionals withMagic [
    file
  ];

  configureFlags = [
    "--with-cajadir=$$out/lib/caja/extensions-2.0"
  ]
  ++ lib.optionals withMagic [
    "--enable-magic"
  ];

  enableParallelBuilding = true;

<<<<<<< HEAD
  passthru.updateScript = gitUpdater {
    url = "https://git.mate-desktop.org/engrampa";
    odd-unstable = true;
    rev-prefix = "v";
  };

  meta = {
    description = "Archive Manager for MATE";
    mainProgram = "engrampa";
    homepage = "https://mate-desktop.org";
    license = with lib.licenses; [
=======
  passthru.updateScript = mateUpdateScript { inherit pname; };

  meta = with lib; {
    description = "Archive Manager for MATE";
    mainProgram = "engrampa";
    homepage = "https://mate-desktop.org";
    license = with licenses; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      gpl2Plus
      lgpl2Plus
      fdl11Plus
    ];
<<<<<<< HEAD
    platforms = lib.platforms.unix;
    teams = [ lib.teams.mate ];
  };
})
=======
    platforms = platforms.unix;
    teams = [ teams.mate ];
  };
}
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
