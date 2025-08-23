{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  intltool,
  pkg-config,
  glib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lxmenu-data";
  version = "0.1.5";

  src = fetchFromGitHub {
    owner = "lxde";
    repo = "lxmenu-data";
    tag = finalAttrs.version;
    hash = "sha256-gWuhE6U33gAzlp21PGZ9qzC3bwi1nXO+WNMNj5xB6SE=";
  };

  nativeBuildInputs = [
    autoreconfHook
    intltool
    pkg-config
    glib
  ];

  meta = {
    homepage = "https://lxde.org/";
    license = lib.licenses.gpl2;
    description = "Freedesktop.org desktop menus for LXDE";
    platforms = lib.platforms.linux;
  };
})
