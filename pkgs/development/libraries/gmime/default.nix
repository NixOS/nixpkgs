{stdenv, fetchurl, pkgconfig, glib, zlib}:

stdenv.mkDerivation {
  name = "gmime-2.4.15";
  src = fetchurl {
    url = http://ftp.acc.umu.se/pub/GNOME/sources/gmime/2.4/gmime-2.4.15.tar.bz2;
    sha256 = "a0a6c9413b057ab5d8a2a2902cbaa5b3a17871af3f94dc8431978c9e0e5f53e1";
  };
  buildInputs = [pkgconfig glib zlib];
}
