{ stdenv, fetchurl, boost, pkgconfig, librevenge, zlib }:

stdenv.mkDerivation rec {
  name = "libwps-${version}";
  version = "0.4.3";

  src = fetchurl {
    url = "mirror://sourceforge/libwps/${name}.tar.bz2";
    sha256 = "0v1a0hj96i4jhb5833336s4zcslzb6md5cnmnrvgywx8cmw40c0c";
  };

  buildInputs = [ boost pkgconfig librevenge zlib ];

  meta = with stdenv.lib; {
    homepage = http://libwps.sourceforge.net/;
    description = "Microsoft Works document format import filter library";
    platforms = platforms.linux;
    license = licenses.lgpl21;
  };
}
