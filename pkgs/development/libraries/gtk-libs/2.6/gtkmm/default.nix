{ stdenv, fetchurl, pkgconfig, gtk, atk, glibmm, libsigcxx}:

stdenv.mkDerivation {
  name = "gtkmm-2.6.4";
  src = fetchurl {
    url = http://ftp.gnome.org/pub/GNOME/sources/gtkmm/2.6/gtkmm-2.6.4.tar.bz2;
    md5 = "f71d1c4a89c4f9e054400f12a82dec5f";
  };

  buildInputs = [pkgconfig gtk atk glibmm libsigcxx];
}

