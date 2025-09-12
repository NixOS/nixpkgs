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
  mateUpdateScript,
}:

stdenv.mkDerivation rec {
  pname = "caja";
  version = "1.28.0";

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
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
