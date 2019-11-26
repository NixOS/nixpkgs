{ autoconf-archive, autoreconfHook, dbus_glib, fetchFromGitHub, gobjectIntrospection, pkgconfig, spidermonkey_52, stdenv, wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "cjs";
  version = "4.2.0";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = "cjs";
    rev = "${version}";
    sha256 = "1yvzvfm1z0d8ca9vk9s0gbsir0ln7mcmlbczf0hh8vzpsg7m1zk5";
  };

  buildInputs = [ autoconf-archive dbus_glib gobjectIntrospection pkgconfig spidermonkey_52 ];
  nativeBuildInputs = [ autoreconfHook wrapGAppsHook ];

  meta = {
    homepage = "http://cinnamon.linuxmint.com";
    description = "JavaScript bindings for Cinnamon" ;

    longDescription = ''
       This module contains JavaScript bindings based on gobject-introspection.

       Because JavaScript is pretty free-form, consistent coding style and unit tests
       are critical to give it some structure and keep it readable.
       We propose that all GNOME usage of JavaScript conform to the style guide
       in doc/Style_Guide.txt to help keep things sane.
    '';

    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.mkg20001 ];
  };
}
