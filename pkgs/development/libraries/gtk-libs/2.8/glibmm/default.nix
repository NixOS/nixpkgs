{stdenv, fetchurl, pkgconfig, glib, libsigcxx}:

stdenv.mkDerivation {
  name = "glibmm-2.6.4";
  src = fetchurl {
    url = http://ftp.gnome.org/pub/GNOME/sources/glibmm/2.6/glibmm-2.6.1.tar.bz2;
    md5 = "e37da352bf581503c5866f0231fd4a74";
  };

  buildInputs = [pkgconfig glib libsigcxx];
}

