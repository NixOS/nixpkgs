{ fetchFromGitHub
, glib
, gobject-introspection
, meson
, ninja
, pkgconfig
, stdenv
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "cinnamon-menus";
  version = "4.6.1";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = pname;
    rev = version;
    sha256 = "1qdaql4mknhzvl2qi1pyw4c820lqb7lg07gblh0wzfk4f7h8hddx";
  };

  buildInputs = [
    glib
    gobject-introspection
  ];

  nativeBuildInputs = [
    meson
    ninja
    wrapGAppsHook
    pkgconfig
  ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/linuxmint/cinnamon-menus";
    description = "A menu system for the Cinnamon project";
    license = [ licenses.gpl2 licenses.lgpl2 ];
    platforms = platforms.linux;
    maintainers = teams.cinnamon.members;
  };
}
