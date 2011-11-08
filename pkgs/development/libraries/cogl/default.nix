{ stdenv, fetchurl_gnome, pkgconfig, mesa, glib, gdk_pixbuf
, pangoSupport ? true, pango, cairo
, libXfixes, libXcomposite, libXdamage, xz }:

stdenv.mkDerivation rec {
  name = src.pkgname;

  src = fetchurl_gnome {
    project = "cogl";
    major = "1"; minor = "8"; patchlevel = "0"; extension = "xz";
    sha256 = "0b0arg0sjky5y4ypgh8dpznd9f1azhi1d5rhf4zbcw2mkl91qmdi";
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
