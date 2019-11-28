{ autoconf-archive, autoreconfHook, dbus_glib, fetchFromGitHub, gobjectIntrospection, pkgconfig, spidermonkey_52, stdenv, wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "cjs";
  version = "4.4.0";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = pname;
    rev = version;
    sha256 = "0q5h2pbwysc6hwq5js3lwi6zn7i5qjjy070ynfhfn3z69lw5iz2d";
  };

  buildInputs = [ autoconf-archive dbus_glib gobjectIntrospection pkgconfig spidermonkey_52 ];
  nativeBuildInputs = [ autoreconfHook wrapGAppsHook ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/linuxmint/cinnamon-translations";
    description = "JavaScript bindings for Cinnamon";

    longDescription = ''
       This module contains JavaScript bindings based on gobject-introspection.

       Because JavaScript is pretty free-form, consistent coding style and unit tests
       are critical to give it some structure and keep it readable.
       We propose that all GNOME usage of JavaScript conform to the style guide
       in doc/Style_Guide.txt to help keep things sane.
    '';

    platforms = platforms.linux;
    maintainers = [ maintainers.mkg20001 ];
  };
}
