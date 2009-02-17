{stdenv, fetchurl, pkgconfig}:

stdenv.mkDerivation rec {
  name = "libsigc++-2.2.3";
  
  src = fetchurl {
    url = "http://ftp.gnome.org/pub/GNOME/sources/libsigc++/2.2/${name}.tar.bz2";
    sha256 = "0hjh7834mbp2n5qnc7n1r3l70j9g06ibv7kbmhix9b101w6ypnak";
  };

  buildInputs = [pkgconfig];

  meta = {
    homepage = http://libsigc.sourceforge.net/;
    description = "A typesafe callback system for standard C++";
  };
}
