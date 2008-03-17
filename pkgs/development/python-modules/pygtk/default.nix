{stdenv, fetchurl, python, pkgconfig, glib, gtk, pygobject, pycairo}:

stdenv.mkDerivation {
  name = "pygtk-2.10.4";

  src = fetchurl {
    url = http://ftp.gnome.org/pub/GNOME/sources/pygtk/2.10/pygtk-2.10.4.tar.bz2;
    sha256 = "1xg8vng42lql29aa5ryva8icc8dwdc7h2y3yn96qjdgl394d96mb";
  };
  
  buildInputs = [python pkgconfig glib gtk];

  propagatedBuildInputs = [pygobject pycairo];
}
