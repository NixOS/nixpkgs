{stdenv, fetchurl, pkgconfig, glib, libsigcxx}:

stdenv.mkDerivation {
  name = "glibmm-2.12.6";
  src = fetchurl {
    url = http://ftp.gnome.org/pub/GNOME/sources/glibmm/2.12/glibmm-2.12.6.tar.bz2;
    md5 = "e078ea7f710233e47e18e4cafbb61be5";
  };

  buildInputs = [pkgconfig glib libsigcxx];
}

