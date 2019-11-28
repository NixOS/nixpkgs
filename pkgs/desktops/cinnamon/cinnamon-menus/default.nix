{ fetchFromGitHub, glib, gobjectIntrospection, meson, ninja, pkgconfig, stdenv, wrapGAppsHook, libxml2, cmake }:

stdenv.mkDerivation rec {
  pname = "cinnamon-menus";
  version = "4.4.0";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = "${pname}";
    rev = "${version}";
    sha256 = "0q4qj28swi2y93fj7pfil68l2cf9gmhbk6jmr8d70l54xf7sigsh";
  };

  buildInputs = [ glib gobjectIntrospection pkgconfig ];
  nativeBuildInputs = [ meson ninja wrapGAppsHook cmake ];

  meta = {
    homepage = "http://cinnamon.linuxmint.com";
    description = "A menu system for the Cinnamon project";

    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.mkg20001 ];
  };
}
