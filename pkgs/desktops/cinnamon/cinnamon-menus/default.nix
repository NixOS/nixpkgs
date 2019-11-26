{ fetchFromGitHub, glib, gobjectIntrospection, meson, ninja, pkgconfig, stdenv }:

stdenv.mkDerivation rec {
  pname = "cinnamon-menus";
  version = "4.2.0";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = "cinnamon-menus";
    rev = "${version}";
    sha256 = "0x7zwymyk72wv1g142iyva0bnz6fgyn32zzlxkcnxwbsr71q7fi7";
  };

  NIX_CFLAGS_COMPILE = "-I${glib.dev}/include/gio-unix-2.0";

  buildInputs = [ glib gobjectIntrospection pkgconfig ];
  nativeBuildInputs = [ meson ninja ];

  postPatch = ''
  '';
}
