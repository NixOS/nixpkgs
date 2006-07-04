{ stdenv, fetchurl, pkgconfig, gtk, atk, glibmm, libsigcxx}:

stdenv.mkDerivation {
  name = "gtkmm-2.8.8";
  src = fetchurl {
    url = http://ftp.gnome.org/pub/GNOME/sources/gtkmm/2.8/gtkmm-2.8.8.tar.bz2;
    md5 = "319a7847f67c5099a78afb495e148143";
  };

  buildInputs = [pkgconfig gtk atk glibmm libsigcxx];
}

