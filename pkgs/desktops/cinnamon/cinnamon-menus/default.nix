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
  version = "5.2.0";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = pname;
    rev = version;
    hash = "sha256-ioluv/GdWCNGP2jQqsyEbHncCFm8iu69yR8QVKQTJk8=";
  };

  buildInputs = [
    glib
    gobject-introspection
  ];

  nativeBuildInputs = [
    meson
    ninja
    wrapGAppsHook
    pkg-config
  ];

  meta = with lib; {
    homepage = "https://github.com/linuxmint/cinnamon-menus";
    description = "A menu system for the Cinnamon project";
    license = [ licenses.gpl2 licenses.lgpl2 ];
    platforms = platforms.linux;
    maintainers = teams.cinnamon.members;
  };
}
