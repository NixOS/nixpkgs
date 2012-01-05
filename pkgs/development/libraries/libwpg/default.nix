{ stdenv, fetchurl, pkgconfig, libwpd, xz }:

stdenv.mkDerivation rec {
  name = "libwpg-0.2.1";

  src = fetchurl {
    url = "mirror://sourceforge/libwpg/${name}.tar.xz";
    sha256 = "0d83nx4rxkrq2sbfbbqpddni56h1328dzmraxyl6vh9p4f19rh5d";
  };

  buildInputs = [ libwpd ];
  buildNativeInputs = [ pkgconfig xz ];

  meta = {
    homepage = http://libwpg.sourceforge.net;
    description = "C++ library to parse WPG";
    maintainers = [ stdenv.lib.maintainers.urkud ];
    platforms = stdenv.lib.platforms.all;
  };
}
