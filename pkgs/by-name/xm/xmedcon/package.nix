{
  stdenv,
  lib,
  buildPackages,
  fetchurl,
  gtk3,
  glib,
  pkg-config,
  libpng,
  zlib,
  wrapGAppsHook3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xmedcon";
  version = "0.26.1";

  src = fetchurl {
    url = "mirror://sourceforge/xmedcon/xmedcon-${finalAttrs.version}.tar.bz2";
    sha256 = "sha256-mf424qgt1FqqnwDQU7b8XLQNJsesLQi07T0LdP1cdPg=";
  };

  buildInputs = [
    gtk3
    glib
    libpng
    zlib
  ];

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook3
  ];

  # xmedcon looks also for a host c compiler when cross-compiling
  # otherwise you obtain following error message:
  # "error: no acceptable C compiler found in $PATH"
  depsBuildBuild = [
    buildPackages.stdenv.cc
  ];

  meta = {
    description = "Open source toolkit for medical image conversion";
    homepage = "https://xmedcon.sourceforge.net/";
    license = lib.licenses.lgpl2Plus;
    maintainers = with lib.maintainers; [
      arianvp
      flokli
    ];
    platforms = lib.platforms.darwin ++ lib.platforms.linux;
  };
})
