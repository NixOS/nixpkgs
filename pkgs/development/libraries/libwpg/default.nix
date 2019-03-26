{ stdenv, fetchurl, pkgconfig, libwpd, zlib, librevenge }:

stdenv.mkDerivation rec {
  name = "libwpg-0.3.3";

  src = fetchurl {
    url = "mirror://sourceforge/libwpg/${name}.tar.xz";
    sha256 = "074x159immf139szkswv2zapnq75p7xk10dbha2p9193hgwggcwr";
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
