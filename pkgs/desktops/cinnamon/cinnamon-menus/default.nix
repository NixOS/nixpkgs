{ fetchFromGitHub
, glib
, gobject-introspection
, meson
, ninja
, pkg-config
, lib
, stdenv
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "cinnamon-menus";
  version = "6.0.0";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = pname;
    rev = version;
    hash = "sha256-zP1jA5Fwxh6QrM5YwJo7SFPWaxkJsv1D84dhIDP5xuI=";
  };

  buildInputs = [
    glib
  ];

  nativeBuildInputs = [
    meson
    ninja
    wrapGAppsHook
    pkg-config
    gobject-introspection
  ];

  meta = with lib; {
    homepage = "https://github.com/linuxmint/cinnamon-menus";
    description = "A menu system for the Cinnamon project";
    license = [ licenses.gpl2 licenses.lgpl2 ];
    platforms = platforms.linux;
    maintainers = teams.cinnamon.members;
  };
}
