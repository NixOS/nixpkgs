{ stdenv, fetchurl, python, pkgconfig, glib, gobjectIntrospection, pycairo, cairo }:
 
stdenv.mkDerivation rec {
  name = "pygobject-3.0.4";
   
  src = fetchurl {
    url = "http://ftp.gnome.org/pub/GNOME/sources/pygobject/3.0/${name}.tar.xz";
    sha256 = "f457b1d7f6b8bfa727593c3696d2b405da66b4a8d34cd7d3362ebda1221f0661";
  };

  configureFlags = "--disable-introspection";

  buildInputs = [ python pkgconfig glib gobjectIntrospection pycairo cairo ];

  meta = {
    homepage = http://live.gnome.org/PyGObject;
    description = "Python bindings for Glib";
  };
}
