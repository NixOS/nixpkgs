{ stdenv, fetchurl, pkgconfig, mesa, glib, gdk_pixbuf
, pangoSupport ? true, pango, cairo
, libXfixes, libXcomposite, libXdamage, xz }:

stdenv.mkDerivation rec {
  name = "cogl-1.8.2";

  src = fetchurl {
    url = mirror://gnome/sources/cogl/1.8/cogl-1.8.2.tar.xz;
    sha256 = "1ix87hz3qxqysqwx58wbc46lzchlmfs08fjzbf3l6mmsqj8gs9pc";
  };

  buildNativeInputs = [ xz pkgconfig ];

  propagatedBuildInputs =
    [ mesa glib gdk_pixbuf libXfixes libXcomposite libXdamage ];

  buildInputs = stdenv.lib.optionals pangoSupport [ pango cairo ];

  meta = {
    description = "A small open source library for using 3D graphics hardware for rendering";
    longDescription =
      ''
        Cogl is a small open source library for using 3D graphics hardware for
        rendering. The API departs from the flat state machine style of OpenGL
        and is designed to make it easy to write orthogonal components that can
        render without stepping on each others toes.
      '';
    inherit (glib.meta) platforms;
  };
}
