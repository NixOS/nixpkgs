{ stdenv, fetchurl, python, pkgconfig, glib }:

stdenv.mkDerivation rec {
  name = "pygobject-2.27.0";
  
  src = fetchurl {
    url = "http://ftp.gnome.org/pub/GNOME/sources/pygobject/2.27/${name}.tar.bz2";
    sha256 = "18mq4mj9s9sw12m6gbbc4iffrq993c7q09v9yahlnamrqn3bv53m";
  };

  configureFlags = "--disable-introspection";

  buildInputs = [ python pkgconfig glib ];

  postInstall = ''
    # All python code is installed into a "gtk-2.0" sub-directory. That
    # sub-directory may be useful on systems which share several library
    # versions in the same prefix, i.e. /usr/local, but on Nix that directory
    # is useless. Furthermore, its existence makes it very hard to guess a
    # proper $PYTHONPATH that allows "import gtk" to succeed.
    cd $(toPythonPath $out)/gtk-2.0
    for n in *; do
      ln -s "gtk-2.0/$n" "../$n"
    done
  '';

  meta = {
    homepage = http://live.gnome.org/PyGObject;
    description = "Python bindings for Glib";
  };
}
