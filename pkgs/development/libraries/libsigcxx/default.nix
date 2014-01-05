{ stdenv, fetchurl, pkgconfig, gnum4 }:

stdenv.mkDerivation rec {
  name = "libsigc++-2.2.11";

  src = fetchurl {
    url = "mirror://gnome/sources/libsigc++/2.2/${name}.tar.xz";
    sha256 = "0ms93q7r8zznsqkfdj1ds9533f0aqfaw3kdkqv154rzmfigh8d4q";
  };

  buildInputs = [ pkgconfig gnum4 ];

  doCheck = true;

  meta = {
    homepage = http://libsigc.sourceforge.net/;
    description = "A typesafe callback system for standard C++";
  };
}
