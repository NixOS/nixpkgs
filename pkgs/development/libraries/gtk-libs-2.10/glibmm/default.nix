{stdenv, fetchurl, pkgconfig, glib, libsigcxx}:

stdenv.mkDerivation {
  name = "glibmm-2.8.9";
  src = fetchurl {
    url = http://ftp.gnome.org/pub/GNOME/sources/glibmm/2.8/glibmm-2.8.9.tar.bz2;
    md5 = "6d23ba91546f51530421de5a1dc81fa8";
  };

  buildInputs = [pkgconfig glib libsigcxx];
}

