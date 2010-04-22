{stdenv, fetchurl, python, pkgconfig, glib}:

stdenv.mkDerivation {
  name = "pygobject-2.20.0";
  src = fetchurl {
    url = http://ftp.gnome.org/pub/GNOME/sources/pygobject/2.20/pygobject-2.20.0.tar.bz2;
    sha256 = "10gsf3i2q9y659hayxyaxyfz7inswcjc8m6iyqckwsj2yjij7sa1";
  };

  buildInputs = [python pkgconfig glib];
}
