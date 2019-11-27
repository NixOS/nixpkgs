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

  NIX_CFLAGS_COMPILE = [ "-I${glib.dev}/include/gio-unix-2.0" "-I${libxml2.dev}/include/libxml2" ];

  configureFlags = [ "--with-libxml=${libxml2.dev}" ];

  buildInputs = [ glib gobjectIntrospection pkgconfig libxml2 ];
  nativeBuildInputs = [ meson ninja wrapGAppsHook cmake ];

  postPatch = ''
  '';

  meta = {
    homepage = "http://cinnamon.linuxmint.com";
    description = "The cinnamon-menu library";

    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.mkg20001 ];
  };
}
