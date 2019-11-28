{ fetchFromGitHub, glib, gobject-introspection, meson, ninja, pkgconfig, stdenv, wrapGAppsHook, libxml2, cmake }:

stdenv.mkDerivation rec {
  pname = "cinnamon-menus";
  version = "4.4.0";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = pname;
    rev = version;
    sha256 = "0q4qj28swi2y93fj7pfil68l2cf9gmhbk6jmr8d70l54xf7sigsh";
  };

  buildInputs = [ glib pkgconfig ];
  nativeBuildInputs = [ meson gobject-introspection ninja wrapGAppsHook ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/linuxmint/cinnamon-menus";
    description = "A menu system for the Cinnamon project";

    platforms = platforms.linux;
    maintainers = [ maintainers.mkg20001 ];
  };
}
