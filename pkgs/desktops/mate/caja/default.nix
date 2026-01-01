{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  pkg-config,
  gettext,
  gtk-layer-shell,
  gtk3,
  libnotify,
  libxml2,
  libexif,
  exempi,
  mate-desktop,
  hicolor-icon-theme,
  wayland,
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
  pname = "caja";
  version = "1.28.0";
  outputs = [
    "out"
    "man"
  ];

  src = fetchurl {
<<<<<<< HEAD
    url = "https://pub.mate-desktop.org/releases/${lib.versions.majorMinor finalAttrs.version}/caja-${finalAttrs.version}.tar.xz";
=======
    url = "https://pub.mate-desktop.org/releases/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    sha256 = "HjAUzhRVgX7C73TQnv37aDXYo3LtmhbvtZGe97ghlXo=";
  };

  patches = [
    # wayland: ensure windows can be moved if compositor is using CSD
    # https://github.com/mate-desktop/caja/pull/1787
    (fetchpatch {
      url = "https://github.com/mate-desktop/caja/commit/b0fb727c62ef9f45865d5d7974df7b79bcf0d133.patch";
      hash = "sha256-2QAXveJnrPPyFSBST6wQcXz9PRsJVdt4iSYy0gubDAs=";
    })
  ];

  nativeBuildInputs = [
    pkg-config
    gettext
    wrapGAppsHook3
  ];

  buildInputs = [
    gtk-layer-shell
    gtk3
    libnotify
    libxml2
    libexif
    exempi
    mate-desktop
    hicolor-icon-theme
    wayland
  ];

  configureFlags = [ "--disable-update-mimedb" ];

  enableParallelBuilding = true;

<<<<<<< HEAD
  passthru.updateScript = gitUpdater {
    url = "https://git.mate-desktop.org/caja";
    odd-unstable = true;
    rev-prefix = "v";
  };

  meta = {
    description = "File manager for the MATE desktop";
    homepage = "https://mate-desktop.org";
    license = with lib.licenses; [
      gpl2Plus
      lgpl2Plus
    ];
    platforms = lib.platforms.unix;
    teams = [ lib.teams.mate ];
  };
})
=======
  passthru.updateScript = mateUpdateScript { inherit pname; };

  meta = with lib; {
    description = "File manager for the MATE desktop";
    homepage = "https://mate-desktop.org";
    license = with licenses; [
      gpl2Plus
      lgpl2Plus
    ];
    platforms = platforms.unix;
    teams = [ teams.mate ];
  };
}
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
