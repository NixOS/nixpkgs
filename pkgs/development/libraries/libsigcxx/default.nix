{ stdenv, fetchurl, pkgconfig, gnum4 }:

stdenv.mkDerivation rec {
  name = "libsigc++-2.2.10";
  
  src = fetchurl {
    url = "http://ftp.gnome.org/pub/GNOME/sources/libsigc++/2.2/${name}.tar.xz";
    sha256 = "8ceb6f2732f5399ef50d5b70f433d49945a12e0900b8f9f43c135866a2e5bf47";
  };

  buildInputs = [ pkgconfig gnum4 ];

  meta = {
    homepage = http://libsigc.sourceforge.net/;
    description = "A typesafe callback system for standard C++";
  };
}
