{ stdenv, fetchurl, python, pkgconfig, glib }:

stdenv.mkDerivation rec {
  name = "pygobject-3.0.4";
  
  src = fetchurl {
    url = "http://ftp.gnome.org/pub/GNOME/sources/pygobject/3.0/${name}.tar.xz";
    sha256 = "f457b1d7f6b8bfa727593c3696d2b405da66b4a8d34cd7d3362ebda1221f0661";
  };

  configureFlags = "--disable-introspection";

  buildInputs = [ python pkgconfig glib ];

  # in a "normal" setup, pygobject and pygtk are installed into the
  # same site-packages: we need a pth file for both. pygtk.py would be
  # used to select a specific version, in our setup it should have no
  # effect, but we leave it in case somebody expects and calls it.
  postInstall = ''
    mv $out/lib/${python.libPrefix}/site-packages/{pygtk.pth,${name}.pth}
  '';

  meta = {
    homepage = http://live.gnome.org/PyGObject;
    description = "Python bindings for Glib";
  };
}
