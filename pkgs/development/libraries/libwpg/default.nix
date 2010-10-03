{ stdenv, fetchurl, pkgconfig, libwpd }:

stdenv.mkDerivation rec {
  name = "libwpg-0.1.3";

  src = fetchurl {
    url = "mirror://sourceforge/libwpg/${name}.tar.bz2";
    sha256 = "086mgy36mia76mpfa2qgn0q44b3aigvvng9snzrxh60v3v9wixa7";
  };

  buildInputs = [ pkgconfig libwpd ];

  meta = {
    homepage = http://libwpg.sourceforge.net;
    description = "C++ library to parse WPG";
    maintainers = [ stdenv.lib.maintainers.urkud ];
    platforms = stdenv.lib.platforms.all;
  };
}
