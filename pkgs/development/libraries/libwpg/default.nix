{ stdenv, fetchurl, pkgconfig, libwpd, zlib, librevenge }:

stdenv.mkDerivation rec {
  name = "libwpg-0.3.0";

  src = fetchurl {
    url = "mirror://sourceforge/libwpg/${name}.tar.xz";
    sha256 = "097jx8a638fwwfrzf6v29r1yhc34rq9526py7wf0ck2z4fcr2w3g";
  };

  buildInputs = [ libwpd zlib librevenge ];
  nativeBuildInputs = [ pkgconfig ];

  meta = {
    homepage = http://libwpg.sourceforge.net;
    description = "C++ library to parse WPG";
    maintainers = [ stdenv.lib.maintainers.urkud ];
    platforms = stdenv.lib.platforms.all;
  };
}
