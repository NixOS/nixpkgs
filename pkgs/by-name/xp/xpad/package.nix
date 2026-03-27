{
  lib,
  stdenv,
  fetchurl,
  fetchpatch2,
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

  patches = [
    (fetchpatch2 {
      url = "https://git.launchpad.net/~neil.mayhew/xpad/+git/xpad-1/patch/?id=637c7b51f1b09a28553a926f594f626d363c526a";
      hash = "sha256-ipebPkCpgj+5vvFS7QciZgH0CTZS12FdeVILfDReVsY=";
    })
  ];

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
