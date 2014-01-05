{ stdenv, fetchurl, pkgconfig, autoreconfHook, python
, dbus_glib, cairo, spidermonkey_185, gobjectIntrospection
}:

let
  version="2.0.0";
in
stdenv.mkDerivation rec {
  name = "cjs-${version}";

  src = fetchurl {
    url = "http://github.com/linuxmint/cjs/archive/${version}.tar.gz";
    sha256 = "16iazd5h2z27v9jxs4a8imwls5c1c690wk7i05r5ds3c3r4nrsig";
  };

  buildInputs = [
    pkgconfig autoreconfHook python
    dbus_glib cairo spidermonkey_185
    gobjectIntrospection
  ];

  preBuild = "patchShebangs ./scripts";

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
    maintainers = [ stdenv.lib.maintainers.roelof ];
  };
}
