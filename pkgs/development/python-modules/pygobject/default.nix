{stdenv, fetchurl, python, pkgconfig, glib}:

stdenv.mkDerivation {
  name = "pygobject-2.20.0";
  src = fetchurl {
    url = http://ftp.gnome.org/pub/GNOME/sources/pygobject/2.20/pygobject-2.20.0.tar.bz2;
    sha256 = "10gsf3i2q9y659hayxyaxyfz7inswcjc8m6iyqckwsj2yjij7sa1";
  };

  buildInputs = [python pkgconfig glib];

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
}
