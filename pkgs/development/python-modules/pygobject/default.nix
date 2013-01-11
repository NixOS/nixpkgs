{ stdenv, fetchurl, python, pkgconfig, glib }:

stdenv.mkDerivation rec {
  name = "pygobject-2.27.0";
  
  src = fetchurl {
    url = "http://ftp.gnome.org/pub/GNOME/sources/pygobject/2.27/${name}.tar.bz2";
    sha256 = "18mq4mj9s9sw12m6gbbc4iffrq993c7q09v9yahlnamrqn3bv53m";
  };

  configureFlags = "--disable-introspection";

  buildInputs = [ python pkgconfig glib ];

  meta = {
    homepage = http://live.gnome.org/PyGObject;
    description = "Python bindings for Glib";
  };
}
