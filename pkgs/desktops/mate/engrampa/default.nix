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
  mateUpdateScript,
  # can be defaulted to true once switch to meson
  withMagic ? stdenv.buildPlatform.canExecute stdenv.hostPlatform,
  file,
}:

stdenv.mkDerivation rec {
  pname = "engrampa";
  version = "1.28.1";

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "nFxMm8+LCO6qjydVONJLTJVQidWK7AMx6JwCuE2FOGo=";
  };

  nativeBuildInputs = [
    pkg-config
    gettext
    itstool
    libxml2 # for xmllint
    wrapGAppsHook3
  ];

  buildInputs =
    [
      caja
      gtk3
      hicolor-icon-theme
      json-glib
      mate-desktop
    ]
    ++ lib.optionals withMagic [
      file
    ];

  configureFlags =
    [
      "--with-cajadir=$$out/lib/caja/extensions-2.0"
    ]
    ++ lib.optionals withMagic [
      "--enable-magic"
    ];

  enableParallelBuilding = true;

  passthru.updateScript = mateUpdateScript { inherit pname; };

  meta = with lib; {
    description = "Archive Manager for MATE";
    mainProgram = "engrampa";
    homepage = "https://mate-desktop.org";
    license = with licenses; [
      gpl2Plus
      lgpl2Plus
      fdl11Plus
    ];
    platforms = platforms.unix;
    maintainers = teams.mate.members;
  };
}
