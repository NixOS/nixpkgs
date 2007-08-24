{ stdenv, fetchurl, pkgconfig}:

stdenv.mkDerivation {
  name = "libsigc++-2.0.16";
  src = fetchurl {
    url = http://ftp.gnome.org/pub/GNOME/sources/libsigc++/2.0/libsigc++-2.0.16.tar.gz;
    md5 = "49b8c091b1be84d9f9801c4c81cd98b8";
  };

  buildInputs = [pkgconfig];
}

