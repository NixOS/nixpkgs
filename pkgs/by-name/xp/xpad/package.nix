{
  lib,
  stdenv,
  fetchurl,
  autoreconfHook,
  pkg-config,
  wrapGAppsHook3,
  glib,
  intltool,
  gtk3,
  gtksourceview4,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xpad";
  version = "5.8.0";

  src = fetchurl {
    url = "https://launchpad.net/xpad/trunk/${finalAttrs.version}/+download/xpad-${finalAttrs.version}.tar.bz2";
    hash = "sha256-8mBSMIhQxAaxWtuNhqzTli7xCvIrQnuxpc/07slvguk=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    wrapGAppsHook3
    intltool
  ];

  buildInputs = [
    glib
    gtk3
    gtksourceview4
  ];

  meta = {
    description = "Sticky note application for jotting down things to remember";
    mainProgram = "xpad";
    homepage = "https://launchpad.net/xpad";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ michalrus ];
  };
})
