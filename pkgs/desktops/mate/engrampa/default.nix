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
  gitUpdater,
  # can be defaulted to true once switch to meson
  withMagic ? stdenv.buildPlatform.canExecute stdenv.hostPlatform,
  file,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "engrampa";
  version = "1.28.2";

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${lib.versions.majorMinor finalAttrs.version}/engrampa-${finalAttrs.version}.tar.xz";
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
      gpl2Plus
      lgpl2Plus
      fdl11Plus
    ];
    platforms = lib.platforms.unix;
    teams = [ lib.teams.mate ];
  };
})
