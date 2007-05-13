{stdenv, fetchurl, python, pkgconfig, glib}:

stdenv.mkDerivation {
  name = "pygobject-2.12.3";
  src = fetchurl {
    url = http://ftp.gnome.org/pub/GNOME/sources/pygobject/2.12/pygobject-2.12.3.tar.bz2;
    sha256 = "0hfsd7ln7j67w0vyrszic9b3d97gddad1y9arjw8i2b6h411xa7g";
  };

  buildInputs = [python pkgconfig glib];
}
