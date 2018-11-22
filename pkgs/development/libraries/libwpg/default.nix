{ stdenv, fetchurl, pkgconfig, libwpd, zlib, librevenge }:

stdenv.mkDerivation rec {
  name = "libwpg-0.3.2";

  src = fetchurl {
    url = "mirror://sourceforge/libwpg/${name}.tar.xz";
    sha256 = "0cwc5zkp210c661l0bvk6q21jg9ak5g8gmy578w5fgfnjymz3yjp";
  };

  buildInputs = [ libwpd zlib librevenge ];
  nativeBuildInputs = [ pkgconfig ];

  meta = with stdenv.lib; {
    homepage = http://libwpg.sourceforge.net;
    description = "C++ library to parse WPG";
    license = with licenses; [ lgpl21 mpl20 ];
    platforms = platforms.all;
  };
}
