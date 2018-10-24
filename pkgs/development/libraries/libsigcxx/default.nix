{ stdenv, fetchurl, pkgconfig, gnum4 }:
let
  ver_maj = "2.10"; # odd major numbers are unstable
  ver_min = "0";
in
stdenv.mkDerivation rec {
  name = "libsigc++-${ver_maj}.${ver_min}";

  src = fetchurl {
    url = "mirror://gnome/sources/libsigc++/${ver_maj}/${name}.tar.xz";
    sha256 = "f843d6346260bfcb4426259e314512b99e296e8ca241d771d21ac64f28298d81";
  };

  nativeBuildInputs = [ pkgconfig gnum4 ];

  doCheck = true;

  meta = with stdenv.lib; {
    homepage = https://libsigcplusplus.github.io/libsigcplusplus/;
    description = "A typesafe callback system for standard C++";
    license = licenses.lgpl21;
    platforms = platforms.all;
  };
}
