{ stdenv, fetchurl, pkgconfig, mesa, glib, gdk_pixbuf, libXfixes, libXcomposite
, libXdamage, libintlOrEmpty
, pangoSupport ? true, pango, cairo, gobjectIntrospection }:

stdenv.mkDerivation rec {
  name = "cogl-1.8.2";

  src = fetchurl {
    url = mirror://gnome/sources/cogl/1.8/cogl-1.8.2.tar.xz;
    sha256 = "1ix87hz3qxqysqwx58wbc46lzchlmfs08fjzbf3l6mmsqj8gs9pc";
  };

  nativeBuildInputs = [ pkgconfig ];

  configureFlags = " --enable-introspection " ; 

  propagatedBuildInputs =
    [ mesa glib gdk_pixbuf libXfixes libXcomposite libXdamage 
gobjectIntrospection ]
    ++ libintlOrEmpty;

  buildInputs = stdenv.lib.optionals pangoSupport [ pango cairo ];

  COGL_PANGO_DEP_CFLAGS
    = stdenv.lib.optionalString (stdenv.isDarwin && pangoSupport)
      "-I${pango}/include/pango-1.0 -I${cairo}/include/cairo";

  NIX_LDFLAGS = stdenv.lib.optionalString stdenv.isDarwin "-lintl";

  meta = with stdenv.lib; {
    description = "A small open source library for using 3D graphics hardware for rendering";
    maintainers = with maintainers; [ lovek323 ];

    longDescription = ''
      Cogl is a small open source library for using 3D graphics hardware for
      rendering. The API departs from the flat state machine style of OpenGL
      and is designed to make it easy to write orthogonal components that can
      render without stepping on each other's toes.
    '';

    platforms = stdenv.lib.platforms.mesaPlatforms;
  };
}
