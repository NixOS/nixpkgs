{ stdenv, fetchurl, python, pkgconfig, glib, gobjectIntrospection, pycairo, cairo }:
 
stdenv.mkDerivation rec {
  name = "pygobject-3.10.2";

  src = fetchurl {
    url = "mirror://gnome/sources/pygobject/3.10/${name}.tar.xz";
    sha256 = "75608f2c4052f0277508fc79debef026d9e84cb9261de2b922387c093d32c326";
  };

  buildInputs = [ python pkgconfig glib gobjectIntrospection pycairo cairo ];

  meta = {
    homepage = http://live.gnome.org/PyGObject;
    description = "Python bindings for Glib";
  };
}
