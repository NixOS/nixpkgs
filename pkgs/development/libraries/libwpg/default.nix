{ stdenv, fetchurl, pkgconfig, libwpd, zlib }:

stdenv.mkDerivation rec {
  name = "libwpg-0.2.2";

  src = fetchurl {
    url = "mirror://sourceforge/libwpg/${name}.tar.xz";
    sha256 = "1kd6d583s9162z023gh5jqrhkjsdig2bsfylw3g38xa4p5vzv6xl";
  };

  buildInputs = [ libwpd zlib ];
  nativeBuildInputs = [ pkgconfig ];

  meta = {
    homepage = http://libwpg.sourceforge.net;
    description = "C++ library to parse WPG";
    maintainers = [ stdenv.lib.maintainers.urkud ];
    platforms = stdenv.lib.platforms.all;
  };
}
