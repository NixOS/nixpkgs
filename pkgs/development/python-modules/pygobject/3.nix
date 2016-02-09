{ stdenv, fetchurl, python, pkgconfig, glib, gobjectIntrospection, pycairo, cairo }:

stdenv.mkDerivation rec {
  name = "pygobject-3.18.2";

  src = fetchurl {
    url = "mirror://gnome/sources/pygobject/3.18/${name}.tar.xz";
    sha256 = "0prc3ky7g50ixmfxbc7zf43fw6in4hw2q07667hp8swi2wassg1a";
  };

  buildInputs = [ python pkgconfig glib gobjectIntrospection ];
  propagatedBuildInputs = [ pycairo cairo ];

  meta = {
    homepage = http://live.gnome.org/PyGObject;
    description = "Python bindings for Glib";
  };
}
