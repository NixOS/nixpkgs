{ stdenv, fetchurl, python, pkgconfig, glib, gobjectIntrospection
, cairo, pycairo, expat }:

stdenv.mkDerivation rec {
  name = "pygobject-3.0.4";
  
  src = fetchurl {
    url = "http://ftp.gnome.org/pub/GNOME/sources/pygobject/3.0/${name}.tar.xz";
    sha256 = "f457b1d7f6b8bfa727593c3696d2b405da66b4a8d34cd7d3362ebda1221f0661";
  };

  buildInputs = [
    python pkgconfig glib gobjectIntrospection
    cairo pycairo expat
  ];

  meta = {
    homepage = http://live.gnome.org/PyGObject;
    description = "Python bindings for Glib";
  };
}
