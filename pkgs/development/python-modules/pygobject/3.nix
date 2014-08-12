{ stdenv, fetchurl, python, pkgconfig, glib, gobjectIntrospection, pycairo, cairo }:

stdenv.mkDerivation rec {
  name = "pygobject-3.12.1";

  src = fetchurl {
    url = "mirror://gnome/sources/pygobject/3.12/${name}.tar.xz";
    sha256 = "0dfsjsa95ix8bx3h8w4bhnz7rymgl2paclvbn93x6qp8b53y0pys";
  };

  buildInputs = [ python pkgconfig glib gobjectIntrospection pycairo cairo ];

  meta = {
    homepage = http://live.gnome.org/PyGObject;
    description = "Python bindings for Glib";
  };
}
