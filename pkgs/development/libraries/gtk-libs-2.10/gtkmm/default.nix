{ stdenv, fetchurl, pkgconfig, gtk, atk, glibmm, libsigcxx}:

stdenv.mkDerivation {
  name = "gtkmm-2.10.7";
  src = fetchurl {
    url = http://ftp.gnome.org/pub/GNOME/sources/gtkmm/2.10/gtkmm-2.10.7.tar.bz2;
    md5 = "d8885c0c5350deb201417cc4032c4e09";
  };

  buildInputs = [pkgconfig gtk atk glibmm libsigcxx];
}

